---
sidebar_position: 7
description: Powerful feature of Scheme that allow to add new control flows
---

# Continuations

## What is continuation?

In Scheme a continuation is a thing that is waiting for an expression to be evaluated. When you have
an expression the arguments are evaluated first, so the function application is waiting for the
arguments to get evaluated before the function can be applied.

If you have code like this:

```scheme
(+ 1 2 <slot>)
```

and `<slot>` is an expression: (e.g.: `(/ 1 10)`)

```scheme
(+ 1 2 (/ 1 10))
;; ==> 31/10
```

then continuation for expression `(/ 1 10)` is `(+ 1 2 <slot>)`. Continuations is the next
expression that needs to be evaluated.

Scheme is unique because it allows accessing continuations. They are first class objects like
numbers or functions.

You can be represented continuation as a function:

if `(/ 1 10)` is `z` the contunuation of the whole expression can be represented as a function,
that may look like this:

```scheme
(lambda (z)
  (+ 1 2 z))
```

## Accessing current continuation

To access the current continuation for an expression, you need to use `call-with-current-continuation`
or its abbreviation `call/cc`. The procedure `call/cc` accepts a single procedure that get the
continuation as first argument:

```scheme
(call/cc (lambda (cc)
           ...))
```

So to capute the continuation expressed as a function you can use code like this:

```scheme
(+ 1 2 (call/cc
        (lambda (c)
          (/ 1 10))))
;; ==> 31/10
```

The continuation saved in `c` capture whole state of the Scheme interpreter. The continuation act as
a procedure that you can pass a single value to it and Scheme will jump in to the place where
continuation was captured with a given value.

## Calling continuations

You can save continuation inside a variable and call it later like a procedure.

```scheme
(define k #f)

(display (+ 1 2 (call/cc
                 (lambda (continuation)
                   (set! k continuation)
                   (/ 1 10)))))
;; ==> 31/10
(k 3)
;; ==> 6
```

Here when you call a continuation `k` with value 6 it restores the state in `(+ 1 2 <slot>)` and
execute that expression again with a value `3` (expression `(+ 1 2 3)`).

:::info

Note that the above code will create an infinite loop when called inside an expression like `let`:

```scheme
(let ()
  (define k #f)
  (display (+ 1 2 (call/cc
                   (lambda (continuation)
                     (set! k continuation)
                     (/ 1 10)))))

  (newline)
  (k 3)) ;; start infinite loop
```

Above code will print 6 in an ifnite loop, because the continuation don't end at display, like in
previous example, only continue executing newline and next call to the continuation.

:::

The continuation act like a procedure and return `#t` with a `procedure?` predicate:

```scheme
(define k (call/cc (lambda (c) c)))
(procedure? k)
;; ==> #t
```

## Early exit

The simple thing you can do with continuations is an early exit. Scheme doesn't have a `return`
expression, but with continuations you can add one.

```scheme
(define (find item lst)
  (call/cc (lambda (return)
             (let loop ((lst lst))
                (if (null? lst)
                    (return #f)
                    (if (equal? item (car lst))
                        (return lst)
                        (loop (cdr lst))))))))
```

Above function is recursive function but the continuations saved before the loop and when calling
return it immedielty jump to the beginning with a given value.

You can even create abstraction of `return` with an [anaphoric
macro](/docs/scheme-intro/macros#anaphoric-macros):

```scheme
(define-macro (alambda args . body)
  `(lambda ,args
     (call/cc (lambda (return)
                ,@body))))
```

and you can use this macro like normal a `lambda`, but you have anaphoric `return` expression:

```scheme
(define exists? (alambda (item lst)
                         (for-each (lambda (x)
                                     (if (equal? x item)
                                         (return #t)))
                                   lst)
                         #f))

(exists? 'x '(a b c d e f))
;; ==> #f
(exists? 'd '(a b c d e f))
;; ==> #t
```

Here `for-each` always iterates over all elements, but with continuation, it will return immediately when
a value is found.

## Loops

You can create loops with continuations:

```scheme
(define (make-range from to)
  (call/cc
   (lambda (return)
     (let ((result '()))
       (let ((loop (call/cc (lambda (k) k))))
         (if (<= from to)
             (set! result (cons from result))
             (return (reverse result)))
         (set! from (+ from 1))
         (loop loop))))))

(make-range 1 10)
;; ==> (1 2 3 4 5 6 7 8 9 10)
```

The first continuation creates an early exit, like in the previous example. But the second `call/cc` use
identity function (it returns continuation). Which means that the continuation is saved in a loop
variable. And each time it's called with `loop` as an argument, it's again assigned that
continuation to loop variable. This is required for the next loop.

## Generators

Some languages have generators and a `yield` keyword. In Scheme, you can create generators with
continuations.

```scheme
(define (make-coroutine-generator proc)
  (define void (if #f #f))
  (define return #f)
  (define resume #f)
  (define yield (lambda (v)
                  (call/cc (lambda (r)
                             (set! resume r)
                             (return v)))))
  (lambda ()
    (call/cc (lambda (cc)
               (set! return cc)
               (if resume
                   (resume void)  ; void? or yield again?
                   (begin (proc yield)
                          (set! resume (lambda (v)
                                         (return (eof-object))))
                          (return (eof-object))))))))
```

The above example came from
[SRFI 158 example implementation](https://github.com/scheme-requests-for-implementation/srfi-158/blob/master/srfi-158-impl.scm#L77-L87).

There are two saved continuations that interact with each other. First is return like in one the
previous examples. And the other is `yield` that saves the point when it was called and return the
value. When the main function is called (the return `lambda`) for the first time it saves the return
from the function for the `yield` and execute the main function with `yield` as argument. But when
you execute the function next time, it call resume, the location when `yield` was called. When yield
is not called it return `eof-object`.

The procedure `make-coroutine-generator` allows defining generators:

```scheme
(define counter (make-coroutine-generator
                 (lambda (yield)
                   (do ((i 0 (+ i 1)))
                     ((<= 3 i))
                     (yield i)))))

(counter) ;; ==> 0
(counter) ;; ==> 1
(counter) ;; ==> 2
(counter) ;; ==> #<eof>
```

With continuations, you can do a lot of cool new flow control structures.

## Generator macro

With help from macros and
[SRFI-139](https://srfi.schemers.org/srfi-139/srfi-139.html) described in section about [Anaphoric Hygienic Macros](/docs/scheme-intro/macros#anaphoric-hygienic-macros) you can create an abstraction over generators:

```scheme
(define-syntax-parameter yield
  (syntax-rules ()
    ((_)
     (syntax-error "Use outside lambda*"))))

(define-syntax lambda*
  (syntax-rules ()
    ((_ args body ...)
     (lambda args
       (make-coroutine-generator
        (lambda (cc)
          (syntax-parameterize
           ((yield (syntax-rules ()
                     ((_ x) (cc x))
                     ((_) (cc)))))
           body ...)))))))

(define gen (lambda* (start end)
              (do ((i start (+ i 1)))
                ((> i end))
                (yield i))))

(define (generator->list gen)
  (let loop ((item (gen))
             (result '()))
    (if (eof-object? item)
        (reverse result)
        (loop (gen) (cons item result)))))

(let ((counter (gen 1 10)))
  (display (generator->list counter))
  (newline))
;; ==> (1 2 3 4 5 6 7 8 9 10)
```

`lambda*` works similar to
[JavaScript generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator):

```javascript
function* gen(start, end) {
    for (let i = start; i <= end; ++i) {
        yield i;
    }
}

Array.from(gen(1, 10));
// ==> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```
