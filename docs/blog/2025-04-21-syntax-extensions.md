---
slug: syntax-extensions
title: "Internals: Syntax Extensions"
authors: jcubic
image: /img/syntax-extensions.png
tags: [parser, javascript, internals]
---

Syntax extensions are a feature in LIPS Scheme that allow users to add new syntax. They work similar
to readers, macro in Common Lisp. You create a sequence of characters that maps to a function that
is executed by the parser, the function works similar to a macro and a result of the function is
returned by the parser in place of the sequence of defined characters.

<!-- truncate -->

## Usage of syntax extension

And Example of syntax extension used by LIPS Scheme are gensym literals.

If you look at the source code in lib/bootstrap.scm file, you will see this code:

```scheme
(set-special! "#:" 'gensym-interal)

(define (gensym-interal symbol)
  "(gensym-interal symbol)

   Parser extension that creates a new quoted named gensym."
  `(quote ,(gensym symbol)))
```

And when you evaluate:
```scheme
#:foo
;; ==> #:foo
```

Which is representation of named gensyms.

```scheme
(gensym "foo")
;; ==>> #:foo
(eq? #:foo #:foo)
;; ==> #f
```

The syntax extension can be a function or a macro, there is only small difference, so in the future
the macro support may be removed.

You can read more about [syntax extension in documentation](/docs/lips/extension#syntax-extensions).

## Implementation

### Specials

In source code, the syntax extensions are called `specials` it was initial name for the quotation symbols like:

* `'` – quote
* `` ` `` – quasiquote
* `` , `` – unquote
* `,@` – unquote-splicing

Later they were extended into a user defined sequence of characters that changed how the parser works.

The first implementation of syntax extension date back into regex based tokenizer. You can read
about this in previous blog post about [Finite-State Machine Lexer](/blog/lexer). The problem with
old regex based tokenize was that the content of the file needed to be converted to tokens before it
was passed to the parser. And because of this the code that added new special sequence, like `"#:"`,
could not be part of the same file as the code that used the new syntax.

This led to the creation of a new Lexer and a new parsing approach.

In the current form `specials` is an inline object that implements an Event Emitter:

```javascript
var specials = {
    LITERAL: Symbol.for('literal'),
    SPLICE: Symbol.for('splice'),
    SYMBOL: Symbol.for('symbol'),
    names: function() {
        return Object.keys(this.__list__);
    },
    type: function(name) {
        try {
            return this.get(name).type;
        } catch(e) {
            console.log({name});
            console.log(e);
            return null;
        }
    },
    get: function(name) {
        return this.__list__[name];
    },
    // events are used in Lexer dynamic rules
    off: function(name, fn = null) {
        if (Array.isArray(name)) {
            name.forEach(name => this.off(name, fn));
        } else if (fn === null) {
            delete this.__events__[name];
        } else {
            this.__events__ = this.__events__.filter(test => test !== fn);
        }
    },
    on: function(name, fn) {
        if (Array.isArray(name)) {
            name.forEach(name => this.on(name, fn));
        } else if (!this.__events__[name]) {
            this.__events__[name] = [fn];
        } else {
            this.__events__[name].push(fn);
        }
    },
    trigger: function(name, ...args) {
        if (this.__events__[name]) {
            this.__events__[name].forEach(fn => fn(...args));
        }
    },
    remove: function(name) {
        delete this.__list__[name];
        this.trigger('remove');
    },
    append: function(name, value, type) {
        this.__list__[name] = {
            seq: name,
            symbol: value,
            type
        };
        this.trigger('append');
    },
    __events__: {},
    __list__: {}
};
```

The code then adds all built-in specials listed above using `append`, but also added an array of them
as read only `__builtins__`. You can access specials object from inside LIPS:

```scheme
lips.specials.__builtins__
;; ==> #("'" "`" ",@" "," "'>")
```

The list of all specials are saved in `specials.__list__` object.

```scheme
(Object.keys lips.specials.__list__)
;; ==> #("'" "`" ",@" "," "'>" "#:" "&" "#\"" "~" "’" "#"
;;       "#u8" "#s8" "#u16" "#s16" "#u32" "#s32" "#f32" "#f64")
```

An interesting element on the list is `"’"`. It's an invalid quotation mark used by [official R7RS
specification](https://standards.scheme.org/unofficial/errata-corrected-r7rs.pdf), and probably also
by some PDF books you can find online. It throws an error when copy and pasted the code from the spec.

```scheme
’(quasiquote (list (unquote (+ 1 2)) 4))
;; ==> Error: You're using an invalid Unicode quote character.
;; ==> Run: (set-special! "’" 'quote) to allow the use of this type of quote at line 1
```

The error suggests to map that sequence to `quote`, so it will act exactly the same as normal
quotation.

```scheme
(set-special! "’" 'quote)
’(quasiquote (list (unquote (+ 1 2)) 4))
;; ==> (quasiquote (list (unquote (+ 1 2)) 4))
```

The reason why it doesn't just work out of the box and throw an error instead, is so the users know
that this is not a valid Scheme syntax, it will make them confused when switching to a different
Scheme implementation.

### Lexer

All specials are included in dynamic `Lexer.rules`, that are part of its State Machine.  So when you
add a new syntax extension, you in the fact modify the Lexer rules and tokens that are created.

Specials are handled the same way as parser constants like `#null` or `#void` and use static method:
`Lexer.literal_rule` to split individual characters into a state machine rules that will match full
sequance of characters.

The lexer caches the dynamic rules in `Lexer._cache.rules`, the cache is invalidated when new syntax
extension is added. The `specials.append()` method trigger the `append` event that invalidate the
cache.

```javascript
specials.on(['remove', 'append'], function() {
    Lexer._cache.valid = false;
    Lexer._cache.rules = null;
});
```

As you can see, the cache is also invalidated when syntax extension is removed. It happens when user
calls `unset-special!`.

```scheme
(set-special! "::" 'foo)

(define (foo x)
  `(quote ,x))

::foo
;; ==> foo

(unset-special! "::")

::foo
;; ==> Unbound variable `::foo'
```

### Parser

When Parser (In `_read_object` private method), get a token (using `peek()` method that calls
`__lexer__.peek()`) that is a special, it checks two cases:

1. if the special is `builtin`, then it just extends it with the long form `'x` become `(quote x)`.
2. if not, it grabs the value of the symbol associated with a given special from environment.

   * If the value is a function, it executes that function
   * If the value is a macro, it evaluates the long form of the syntax extension

   Both cases use `_with_syntax_scope` method that add `stdin` as `ParserInputPort` and extends the
   `lips` global to add `__parser__` and point it to the instance of the Parser. This way the syntax
   extension can access functions like `read` or `read-char` or can also manipulate the parser instance.

### Conclusion

And this is whole implementation. Syntax extensions in LIPS Scheme are a powerful feature, enabling
users to define custom syntax beyond just plain macros. Even that their implementation is not that
hard to understand, they contain a lot of creative potential, allowing developers to extend the
language in new ways.

