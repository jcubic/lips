---
slug: new-beta-continuations-and-tco
title: "LIPS Scheme 1.0.0-beta.22 with Continuations and TCO"
authors: jcubic
image: /img/continuations.png
tags: [release]
---

I'm excited to introduce a new beta version of LIPS Scheme. The most important features of this version
are full continuations and TCO (Tail Call Optimization). They were inspired by
[js-scheme](https://bluishcoder.co.nz/jsscheme/) by Alex Yakovlev.

<!-- truncate -->

## Continuations

You can now finally play with continuations. Here is a simple example of an early exit from a recursive named let.

```scheme
(define (find fn lst)
  (call/cc (lambda (return)
             (let loop ((lst lst))
                (if (null? lst)
                    (return #f)
                    (if (fn (car lst))
                        (return lst)
                        (loop (cdr lst))))))))

(find (lambda (x)
        (print x)
        (zero? x))
      '(2 1 0 1 2 3 4 5 6 7))
;; ==> 2
;; ==> 1
;; ==> 0
;; ==> (0 1 2 3 4 5 6 7)
```

You can read about continuations in [Scheme Tutorial](/docs/scheme-intro/continuations)

## JavaScript generators

Finally, LIPS has native JavaScript generators. If you're not familiar with generators, they are like a
function that can yield a value, which suspends the execution and then resumes it later.

```javascript
function* integers(n) {
    let i = 0;
    while (i < n) {
        yield i++;
    }
}

for (const i of integers(10)) {
    console.log(i);
}

// ==> 0
// ==> 1
// ==> 2
// ==> 3
// ==> 4
// ==> 5
// ==> 6
// ==> 7
// ==> 8
// ==> 9
```

Now, thanks to continuations, the same thing can be done in LIPS Scheme.

```scheme
(define (integers x)
  (generator (lambda (yield)
               (let loop ((i 0))
                 (if (< i x)
                     (begin
                       (yield i)
                       (loop (+ i 1))))))))

(Array.from (integers 10))
;; ==> #(0 1 2 3 4 5 6 7 8 9)
```

You can also use the generator with the `do-iterator` macro:

```scheme
(do-iterator
 (i (integers 10000))
 ((= i 10) #void)
 (print i))
;; ==> 0
;; ==> 1
;; ==> 2
;; ==> 3
;; ==> 4
;; ==> 5
;; ==> 6
;; ==> 7
;; ==> 8
;; ==> 9
```

You can also define an async generator:

```scheme
(define (title url)
  (let ((re #/<h1>([^>]+)<\/h1>/))
    (--> (fetch url)
         (text)
         (match re)
         1)))

(define (titles urls)
  (async-generator (lambda (yield)
                     (let loop ((urls urls))
                       (if (not (null? urls))
                           (let ((url (car urls)))
                             (yield (title url))
                             (loop (cdr urls))))))))

(define urls '("https://scheme.org.pl/test/"
               "https://terminal.jcubic.pl/"))

(write (Array.fromAsync (titles urls)))
;; ==> #("Scheme Programming Language"
;; ==>  "jQuery Terminal: JavaScript Web Based Terminal Emulator")
```

The JavaScript generators are a syntax sugar for the
[JavaScript iterator protocol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)

The implementation of generator use that protocol, the missing piece to be able to create a generator in LIPS
were continuations.

This is the source code that was based for the generator:

```scheme
(define (generator proc)
  "(generator function)

   Higher order function that accepts a function with a single argument
   (usually yield). Function returns JavaScript async generator that
   produce values for each call to yield."
  (define void (if #f #f))
  (define return #f)
  (define resume #f)
  (define (yield v)
    (call/cc (lambda (r)
               (set! resume r)
               (return v))))
  (define (next)
    (let ((value (call/cc
                  (lambda (cc)
                    (set! return cc)
                    (if resume
                        (resume void)
                        (begin
                          (proc yield)
                          (set! resume
                                (lambda (v)
                                  (return (eof-object))))
                          (return (eof-object))))))))
      `&(:value ,value :done ,(eof-object? value))))

  (let* ((iterator `((next . ,next)
                     (,Symbol.iterator . ,(lambda () this)))))
    (alist->object iterator)))
```

The implementation was inspired by
[srfi-158 implementation of `make-coroutine-generator`](https://github.com/scheme-requests-for-implementation/srfi-158).

The iterator in JavaScript is an object that has a next property that is a function that returns objects in a format:

```javascript
{
    "value": /* return value */,
    "done": /* boolean indicator if the iteration ended */
}
```

There are two types of iterators: the normal iterator that has a `Symbol.iterator` property that
holds a function, which returns the iterator. Or async iterator with `Symbol.asyncIterator` that has
the same function. The function `async-generator` uses `Symbol.asyncIterator` instead of `Symbol.iterator`.

For working with an iterator, there is a macro `do-iterator` that works similarly to the `do` macro but accepts
iterator (it also has a single list as the first element instead of a list of lists).

There is also the `iterator->array` function. Both macro and function are iterator agnostic and accept both iterators.

The difference is that the next function in the async iterator can return a Promise.

## Tail Call Optimizations

This is another feature implemented together with continuations inspired by JS-Scheme. You can now
use recursion that doesn't consume the stack. There are still some memory increases, but the
memory-allocated objects are garbage collected during the long loop.

Here is an example that you can test:

```scheme
(define (sum n)
  (let loop ((n n) (acc 0))
    (if (<= n 0)
        acc
        (loop (- n 1) (+ acc n)))))

(sum 100000)
;; ==> 5000050000
```

## "Stack" Trace

You can create a 'stack' trace out of continuations:

```scheme
(trace #t)

(let ((x 10))
  (let ((y 20))
    (stack-trace (call/cc (lambda (cc) cc)))))

;; ==> [0]: (let ((x 10)) (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc)))))
;; ==> [1]: (let ((y 20)) (stack-trace (call/cc (lambda (cc) cc))))
;; ==> [2]: (stack-trace (call/cc (lambda (cc) cc)))
;; ==> [3]: (call/cc (lambda (cc) cc))
;; ==> [4]: (lambda (cc) cc)

(trace #f)
```

You can also directly inspect the continuations and extract meta information:

```scheme
(trace #t)

(define cc (let ((x 10))
             (let ((y 20))
               (call/cc (lambda (cc) cc)))))

(define trace (cc.trace (lambda (cc i)
                          (let ((code cc.__code__))
                            `&(:line    ,code.__line__
                               :col     ,code.__col__
                               :offset  ,code.__offset__
                               :file    ,code.__file__)))))

(console.log trace)

;; ==> [
;; ==>   { line: 2, col: 0, offset: 12, file: 'stack-trace.scm' },
;; ==>   { line: 2, col: 11, offset: 23, file: 'stack-trace.scm' },
;; ==>   { line: 3, col: 13, offset: 50, file: 'stack-trace.scm' },
;; ==>   { line: 4, col: 15, offset: 79, file: 'stack-trace.scm' },
;; ==>   { line: 4, col: 24, offset: 88, file: 'stack-trace.scm' }
;; ==> ]
(trace #f)
```

Trace also enables exception augmentation. In REPL you can enable it with the -t/--trace flag.

```scheme
(trace #t)
(print (try (throw (new Error "Nasty")) (catch (e) e.message)))
(trace #f)
;; ==> Error: Nasty at line 2 and column 19 in err.scm
```

Metadata also works when reading from a port:

```scheme
(trace #t)
(let ((port (open-input-string "(one two three)")))
  (print (map (lambda (symbol) symbol.__col__) (read port))))
;; ==> (1 5 9)
(trace #f)
```

## Syntax extensions

Parsing syntax extensions was improved. Now you can use simple regex-based syntax. There were also fixed
extensions that start with `#`.

```scheme
(set-special! #/#[0-9]+a/ (lambda (list) `(quote ,list)) lips.specials.LITERAL)

(print #12a((1 2 3) (1 2 3)))
;; ==> ((1 2 3) (1 2 3))
```

The regex is converted to [Finite State Machine in Lexer](/blog/lexer), that's why not all regex
syntax is supported, only character classes and `+`/`*` quantifiers.

## Quasiquote and Macroexpand

Quasiquote was rewritten based on a paper
["Quasiquotation in Lisp" by Alen Bawden](https://duckduckgo.com/?q=Alan+Bawden+lisp+quasi+quotation+in+lisp&ia=web).

Same as `macroexpand`/`macroexpand-1` that are now functions similar to Common Lisp.

## Speed improvements

A few optimizations were implemented. One of them is two new directives, simiar to `#!fold-case`,
created as syntax extensions:

```scheme
#!no-promise
#!no-cycle
```

They disable promise resolution and list cycle checking. If you know that your code doesn't use them,
you can enable them. You can also toggle them inside the code. To enable promise resolution and
cycle detection. You can use complementary directives:

```scheme
#!promise
#!cycle
```

:::info

Because they are not part of the parser, they return `#void` (JavaScript undefined).

:::


Here is a breakdown of the speed improvements. I've created two simple scripts that test the speed.

First I run it on version 21 and then on 22 with an additional two optimization directives.

### First example

Here is the first code. A while loop is a macro that maps into a named let that uses tail recursion.

```scheme
(define (sum n)
  (let ((sum 0) (list (range n)))
    (while (not (null? list))
      (set! sum (+ sum (car list)))
      (set! list (cdr list)))
    sum))

(define (myLoop x)
  (let ((i 100))
    (while (> i 0)
      (let loop ((i x))
        (if (> i 0)
            (loop (- i 1))))
      (set! i (- i 1))
      (sum 100))))

(define (timed-loop x)
  (begin
    (globalThis.console.time "speed")
    (myLoop x)
    (globalThis.console.timeEnd "speed")))

(timed-loop 100)
```


### Speed comparison

| Version | Speed  |promise directive | both directives |
|---------|--------|------------------|-----------------|
| beta.21 | 1.507s | -                | -               |
| beta.22 | 1.036s | 987.585ms        | 829.411ms       |

Up to 1.82x speed improvement

### Second example

Here is another script with the `Array::forEach` Ccheme callback.

```scheme
(define (calc x)
  (let ((x (* x x)))
    (+ x x)))

(define (myLoop x)
  (let ((i 100))
    (while (> i 0)
      (set! i (- i 1))
      (--> (Array.from &(:length 1000) (lambda (_ i) i)) (forEach calc)))))

(define (timed-loop x)
  (begin
    (globalThis.console.time "speed")
    (myLoop x)
    (globalThis.console.timeEnd "speed")))

(timed-loop 100)
```

### Speed comparison

| Version | Speed  |promise directive | both directives |
|---------|--------|------------------|-----------------|
| beta.21 | 4.304s | -                | -               |
| beta.22 | 1.820s | 1.624s           | 1.533s          |

Up to 2.81× speed improvement

## Full Changelog

### Breaking
* syntax extensions now expect a reference to a function or a macro
* replace `set-obj!` with `set-object!` [#439](https://github.com/jcubic/lips/issues/439)
* REPL -t/--trace will toggle only JavaScript stack, Scheme stack traces are now always on
* stack trace in exceptions is now `Error::__stack__`
* remove `..` macro [#500](https://github.com/jcubic/lips/issues/500)
* `macroexpand` is now a function (like in Common Lisp) instead of a macro
* remove `parent.frame` and `parent.frames`
* remove `Symbol(__data__)` from quoted data
* swap `fold-right` and `fold-left`
* `truncate` now properly return integer
* `lips -e` doesn't print the output anymore
* remove `with-tags` macro and `make-tags` function
### Features
* add debugging helpers (`is-debug`, `set-debug!`, and `inspect`)
* add `set-hash-syntax!` function [#477](https://github.com/jcubic/lips/issues/477)
* `Environment:doc` now returns doc string for functions and macros additional to variables
* improve and unify Syntax Errors
* meta info from Runtime errors in REPL can be enabled with `-m`/`--meta`
* implement simple regex based syntax-extension
* recursion performance improvements
* new interpreter with TCO and Continuations inspired by js-scheme [#127](https://github.com/jcubic/lips/issues/127)
* new higher order function `matcher` that return function that check if object is the same
* new `stack-trace` and `trace` functions
* improve error handling
* add core `^` bitwise xor function
* add `generator` and `make-coroutine-generator` functions
* add support for `truncate` on rational numbers
* add `#!cycle`/`#!no-cycle`, `#!trace`/`#!no-trace` and `#!promise`/`#!no-promise` directives
### Bugfix
* fix doc string for `make-rectangular`
* `-inf.0`/`+inf.0` are now real lips numbers
* fix boolean operation on `+nan.0` [#472](https://github.com/jcubic/lips/issues/472)
* fix swallowed errors in async syntax extensions [#470](https://github.com/jcubic/lips/issues/470)
* fix cleanup after parsing syntax extension throws an error
* fix unwanted argument unboxing from lips constructors [#483](https://github.com/jcubic/lips/issues/483)
* fix warning about rejected Promise in try..catch [#482](https://github.com/jcubic/lips/issues/482) [#484](https://github.com/jcubic/lips/issues/484)
* fix overwriting internal state when using multiple Interpters [#495](https://github.com/jcubic/lips/issues/495)
* fix syntax extension conflict with datum syntax
* fix `unset-special!` not removing regex based syntax extensions
* fix hygiene of named `let`
* fix module path when load throw exception
* fix handling unsupported operations on rational numbers
* fix exit code for `lips -e` on exception
* fix `vector-fill!` off-by-one error
* fix parsing of syntax extensions

