---
sidebar_position: 4
description: Environments in LIPS are first class objects
---

# Environments

Environments in LIPS are first class objects that you can interact with.
Scheme spec define procedure `(interactive-environment)` LIPS add also `(current-environment)`.


```scheme
(let ((x 10))
  (eval '(+ x x) (current-environment)))
;; ==> 20
```

## Environment chain

Environments are created in a chain. In JavaScript there is a notion of scope chain the same,
is in Scheme. But with environment object you can access that chain.

```scheme
(let ((x 10))
  (let ((x 20))
    (print (eval '(+ x x) (current-environment)))
    (print (eval '(+ x x) (. (current-environment) '__parent__)))))
;; ==> 40
;; ==> 20
```

## Changing environment without eval

In LIPS you can change the environment with `letenv` syntax:

```scheme
(define env (let ((x 10) (y 20))
              (current-environment)))

(letenv env
  (+ x y))
;; ==> 30
```

## Scheme Report Environments
Scheme standard provide environments for given version of the [R<sup>n</sup>RS
specification](/docs/scheme-intro/what-is-lisp#standards) in a form of a function
`scheme-report-environment`.

You can use this function in LIPS with version 5 and 7 to get R<sup>5</sup>RS or R<sup>7</sup>RS.

:::info

Note that some of the functions from R<sup>5</sup>RS may have features of R<sup>7</sup>RS since
some of them got additional arguments. R<sup>n</sup>RS is backward compatible.

:::

You can use this function with `eval` or `letenv`:

```scheme
(let ((env (scheme-report-environment 7)))
  (letenv env
     (display (+ 1 2))))
;; ==> 3
(letenv (scheme-report-environment 7)
  (display (--> "string" (toUpperCase))))
;; ==> Unbound variable `-->'
(letenv (scheme-report-environment 7)
   (write (vector-map + #(1 2 3) #(4 5 6 7))))
;; ==> #(5 7 9)
(letenv (scheme-report-environment 5)
   (write (vector-map + #(1 2 3) #(4 5 6 7))))
;; ==> Unbound variable `vector-map'
```

R<sup>5</sup>RS doesn't support `vector-map` that was added in version R<sup>7</sup>RS. The same
both Scheme versions doesn't support LIPS extensions like [`-->`
macro](/docs/lips/intro#helper-macros-and-functions).

## Introspection

Since environments are JavaScript objects you can access its properties like `__name__` or `__env__`.

```scheme
(let ((x 10) (y 20))
  (write (Object.keys (. (current-environment) '__env__))))
;; ==> #("x" "y")
```

`__env__` property is an object with the variables. Here it returns variables defined in let.

```scheme
(let ((x 10) (y 20))
  (let ((env (current-environment)))
    (write env.__name__)))
;; ==> "let"
```

Here you can access name of the lexical environment.

## Global environment

in `lips.env` is user global environment but real global environment where all functions and macros that are
located (it's also a place where names from bootstrapping are saved) is `lips.env.__parent__`.

If you want to really overwrite builtin function.

```scheme
(define-macro (define x)
  `(print ,x))

(define 10)
;; ==> 10
(unset! define)
(define foo 10)
(print foo)
;; ==> 10
```

If you execute this code in REPL or in a script it will only add `define` into `interaction-environment`.
If you really want to overwrite `define` you can (not that you should):

```scheme
(letenv lips.env.__parent__
  (define-macro (define x)
    `(print ,x)))

(define 10)
;; ==> 10
(unset! define)
(define foo 10)
;; ==> Unbound variable `define'
```

The only time you may want to use `lips.env.__parent__` when you bootstrap the LIPS Scheme system.

```scheme
(letenv lips.env.__parent__
  (load "<path or URL>/dist/std.xcb"))
```
