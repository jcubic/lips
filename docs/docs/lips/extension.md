---
sidebar_position: 6
description: A way to extend LIPS syntax, not only with macros
---

# Extending LIPS

There are two ways to extend LIPS Scheme, one is through [macros](#macros) and the other ways is with
[syntax extensions](#syntax-extensions).

## Macros

LIPS allows creating Lisp macros and Scheme hygienic macros. Right now the limitations of macros are
that they are runtime.  There is no expansion time. Macros act like function calls, but they
transform the code, and the interpreter evaluates the code that is returned by the macro. They were
implemented like this because this is how I understood the macros when they first got implemented.
There is a [plan to create proper macro expansion](https://github.com/jcubic/lips/issues/169).

Quasiquote works with object literals, like with vectors:

```scheme
(let* ((x 10)
       (y 20)
       (obj `&(:x ,x :y ,y)))
  (print obj))
```

to define a Lisp macro, you use syntax defined in the [Scheme Tutorial about Macros](/docs/scheme-intro/macros).

```scheme
(define-macro (for var start end . body)
  `(for-each (lambda (,var)
               ,@body)
             (range ,start ,(+ end 1))))

(let ((result (vector)))
  (for i 10 20
       (result.push i))
  (print result))
;; ==> #(10 11 12 13 14 15 16 17 18 19 20)
```

You can define macros that create shorthand syntax like in JavaScript:

```javascript
const x = 10;
const y = 20;
const obj = { x, y };
console.log(obj);
// { x: 10, y: 20 }
```

You can create a macro that will work the same in LIPS Scheme:

```scheme
(define (symbol->key symbol)
  (string->symbol (string-append ":" (symbol->string symbol))))

(define-macro (expand . args)
  `(object ,@(reduce (lambda (symbol acc)
                       (let ((key (symbol->key symbol)))
                         (append acc (list key symbol))))
                     '()
                     args)))
(let* ((x 10)
       (y 20)
       (obj (expand x y)))
  (print obj))
;; ==> &(:x 10 :y 20)
```

### Hygienic macros
LIPS defines hygienic macros in the form of standard `syntax-rules` expressions. Note that there are
know bugs in `syntax-rules` see [issue #43 on GitHub](https://github.com/jcubic/lips/issues/43) and
[unit tests](https://github.com/jcubic/lips/blob/devel/tests/syntax.scm) that have tests marked as
failing.

If you find a case of failing macro, don't hessitate to create an issue. You can also check if your
case is not already listed on above links. You can also just create a comment on issue #43 with your
broken test case.

LIPS Scheme define those extensions to syntax-rules macros:

* [SRFI-46](https://srfi.schemers.org/srfi-46/srfi-46.html) (changing ellipsis symbol: see
  [Nested Hygienic Macros](/docs/scheme-intro/macros#nested-hygienic-macros)
* [SRFI-139](https://srfi.schemers.org/srfi-139/srfi-139.html) see
  [Syntax Parameters](/docs/scheme-intro/macros#anaphoric-hygienic-macros)
* [SRFI 147](https://srfi.schemers.org/srfi-147/srfi-147.html) allow defining new syntax-rules transformers

### Macroexpand
LIPS define `macroexpand` and `macroexpand-1` like in [Common Lisp](http://clhs.lisp.se/Body/f_mexp_.htm).

## Syntax Extensions

Syntax extensions are a way to add new syntax to LIPS Scheme. They are executed at parse
time. Object literals and vector literals are added using syntax extensions. Syntax extensions
modify the Parser and allow adding new behavior at parse time.

To add a syntax extension, you use the following:

Define a function:

```scheme
(define (my-function number)
  `(list ,number ,number))

(set-special! "##" my-function lips.specials.LITERAL)
```

The syntax extension can point to a macro or a function. When an extension is a function, it's
invoked, and the result data is returned from the parser:

If you define the function like this and execute it:

```scheme
##10
;; ==> (10 10)
```

To see the expansion of syntax extension, you can use `lips.parse`:

```scheme
(lips.parse "##10")
;; ==> #((list 10 10))
```

:::info

The `lips.parse` function returns an array/vector of parsed expressions.

:::

There are 3 types of syntax extensions: `SPLICE`, `LITERAL`, and `SYMBOL`. You define them using
constants defined in the `lips.specials` object.

* `LITERAL` - used above to pass its argument as is; with literal syntax extension, you can execute
  it on any argument. This is the default when no constant in `set-special!` is used.
* `SPLICE` - if you execute syntax `##(1 2 3)` the arguments will be spliced, so the function or a
  macro needs to use an improper list. Or use named arguments if syntax accepts a fixed number of
  arguments.
* `SYMBOL` - this type of extension doesn't accept any arguments and can be used to define parser
  constants.

### Splice syntax extensions

```scheme
(define (complex real imag)
  (make-rectangular real imag))

(set-special! "##" complex lips.specials.SPLICE)
```

This syntax extension will define complex numbers and will work only on lists:

```scheme
##(10 20)
;; ==> 10+20i
```

Since it's a macro, it evaluates at parse time:

```scheme
(lips.parse "##(10 20)")
;; ==> #(10+20i)
```

With splice syntax extension, you can limit the number of arguments (remember that LIPS doesn't check
[arity](https://en.wikipedia.org/wiki/Arity)).

```scheme
(define (complex . args)
  (if (not (= (length args) 2))
      (throw "Invalid invocation of ## syntax extension")
    (apply make-rectangular args)))
```

```scheme
(lips.parse "##(10 20)")
;; ==> #(10+20i)
(lips.parse "##(1 2 3)")
;; ==> Invalid invocation of ## syntax extension
```

### Symbol syntax extensions

The last type of syntax extensions are symbols; they don't accept any arguments and can be used to
define parser constants.

```scheme
(set-special! "#nil" (lambda () '()) lips.specials.SYMBOL)
```

This will define the constant `#nil`. It's different from the `nil` variable:

```scheme
(define nil '())

(eq? nil #nil)
;; ==> #t
(eq? (car '(nil)) (car '(#nil)))
;; ==> #f
(symbol? (car '(nil)))
;; ==> #t
(symbol? (car '(#nil)))
;; ==> #f
(eq? (car '(#nil)) '())
;; ==> #t
```

You can define a [macro](#macros) that will define a constant:

```scheme
(define-macro (define-constant name value)
  `(set-special! ,name (lambda () ,value) lips.specials.SYMBOL))
```

And you can use it as the following:

```scheme
(print '(zero))
;; ==> (zero)

(define-constant "zero" 0)

(print '(zero))
;; ==> '(0)
```

You can also define your own hash syntax:

```scheme
(define-constant "#zero" 0)

(print '(#zero))
;; ==> '(0)
```

:::warning

If you try to use '(#zero) without defining the constant, you will get an error, because hash is the syntax for [vector](/docs/scheme-intro/data-types#vectors) literals.

:::

### Autogensyms

With syntax extensions you can define autogensyms expressions:

```scheme
(define (keyword symbol)
  `(gensym ',symbol))

(set-special! "#:" keyword lips.specials.LITERAL)

(let ((x #:foo))
  (write x))
;; ==> #:foo
```

This allows the creation of named [gensyms](/docs/lips/intro#gensyms) that are unique:

```scheme
(eq? #:foo #:foo)
;; ==> #f
```

You can use them with Lisp macros instead of `gensym` expressions.

:::tip

The autogensyms are actually part of the standard library.

:::

### String interpolation

With syntax extensions you can create string interpolation that expand into a Scheme code:

```scheme
(define (interpolate str)
  (typecheck "interpolate" str "string")
  (let* ((re #/(\$\{[^\}]+\})/)
         (parts (--> str (split re) (filter Boolean))))
    `(string-append ,@(map (lambda (part)
                             (if (not (null? (part.match re)))
                                 (let* ((expr (part.replace #/(^\$\{)|(\}$)/g ""))
                                        (port (open-input-string expr))
                                        (value (with-input-from-port port read)))
                                   `(repr ,value))
                                 part))
                           (vector->list parts)))))

(set-special! "$:" interpolate)

(pprint (macroexpand-1 '(let ((x 10)) $:"x = ${(+ x 2)}")))
;; ==> (let ((x 10))
;; ==>   (string-append "x = " (repr (+ x 2))))

(let ((x 10))
  $:"x = ${(+ x 2)}")
;; ==> "x = 12"
```

The limitation of this solution is that you can't use strings inside `${ ... }`. It will break the
Lexer. In order to have full string interpolation, you need to read the parser stream (see [Standard
input](#standard-input) inside syntax extensions).

### Accessing the Parser

In LIPS syntax extensions you can access the parser instance, so you can implement a syntax
extension that returns the line number:

```scheme
(define (line-num)
  (let* ((lexer lips.__parser__.__lexer__)
         (token lexer.__token__))
    (write token)
    (newline)
    ;; line number start from 0
    (+ token.line 1)))

(set-special! "#:num" line-num lips.specials.SYMBOL)

(print (list
        #:num
          #:num))
;; ==> &(:token "#:num" :col 8 :offset 260 :line 11)
;; ==> &(:token "#:num" :col 10 :offset 274 :line 12)
;; ==> (12 13)
```

### Standard input
In syntax extensions, `current-input-port` points into the parser stream. So you can implement
your own parser logic. The best way to implement a custom syntax extension (that works similarly to
Common Lisp reader macros).

```scheme
(define (raw-string)
  (if (char=? (peek-char) #\")
      (begin
        (read-char)
        (let loop ((result (vector)) (char (peek-char)))
          (read-char)
          (if (char=? char #\")
              (apply string (vector->list result))
              (loop (vector-append result (vector char)) (peek-char)))))))

(set-special! "$:" raw-string lips.specials.SYMBOL)

(print $:"foo \ bar")
;; ==> "foo \\ bar"
```

This extension implements raw strings, like in Python, where you don't need to escape the characters
that are treated literally.  Similarly, you can implement strings that use backticks; you only need
to replace `#\"` with `` #\` ``.

```scheme
(define (raw-string)
  (if (char=? (peek-char) #\`)
      (begin
        (read-char)
        (let loop ((result (vector)) (char (peek-char)))
          (read-char)
          (if (char=? char #\`)
              (apply string (vector->list result))
              (loop (vector-append result (vector char)) (peek-char)))))))

(set-special! "$:" raw-string lips.specials.SYMBOL)

(print $:`foo \ bar`)
;; ==> "foo \\ bar"
```

With this feature in hand you can implement full string interpolation (that will probably be part of
LIPS Scheme in the future).

### Limitations

The limitation of syntax extensions is that you can't define a variable that starts with the same
characters as the syntax extension. This may be a benefit and not a limitation. You also need to be
careful about the performance of your extensions.

## New Homoiconic Data Types

With LIPS, you can define representations of custom data types that are the same when printed and read.

To create a custom representation of a new data type, you can use the `set-repr!` expression. It only works
with JavaScript classes.  But Scheme records in LIPS define new JavaScript classes. So you can create
new records and create different representations for them.

```scheme
(define-record-type :Person
  (make-person name age)
  person?
  (name person-name set-name!)
  (age person-age set-age!))

(set-repr! :Person (lambda (obj quot)
                     (string-append "(make-person "
                                    (repr (person-name obj) quot)
                                    " "
                                    (repr (person-age obj) quot)
                                    ")")))

(write (make-person "Mick Jagger" 80))
;; ==> (make-person "Mick Jagger" 80)
(display (make-person "Mick Jagger" 80))
;; ==> (make-person Mick Jagger 80)
```

As you can see, the `display` doesn't quote the strings because of the `repr` expression that uses
the `quot` argument to the `set-repr!` handler.

### Combining with syntax extensions

You can combine syntax extensions with custom representation:

```scheme
(set-repr! :Person (lambda (obj quot)
                     (string-append ":P("
                                    (repr (person-name obj) quot)
                                    " "
                                    (repr (person-age obj) quot)
                                    ")")))

(set-special! ":P" make-person lips.specials.SPLICE)

(write :P("Mick Jagger" 80))
;; ==> :P("Mick Jagger" 80)
```
