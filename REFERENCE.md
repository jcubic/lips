# Function Reference

## -
```
(- n1 n2 ...)
(- n)

Subtracts n2 and subsequent numbers from n1. If only one argument is passed
it will negate the value.
```

## -->
```
Helper macro that simplifies calling methods on objects. It works with chaining
usage: (--> ($ "body")
            (css "color" "red")
            (on "click" (lambda () (display "click"))))

       (--> document (querySelectorAll "div"))

       (--> (fetch "https://jcubic.pl")
            (text)
            (match #/<title>([^<]+)<\/title>/)
            1)

       (--> document
            (querySelectorAll ".cmd-prompt")
            0
            'innerHTML
            (replace #/<("[^"]+"|[^>])+>/g ""))

       (--> document.body
            (style.setProperty "--color" "red"))
```

## .
```
(. obj . args)
(get obj . args)

This function uses an object as a base and keeps using arguments to get the
property of JavaScript object. Arguments need to be a strings.
e.g. `(. console "log")` if you use any function inside LIPS it
will be weakly bound (can be rebound), so you can call this log function
without problem unlike in JavaScript when you use
`var log = console.log`.
`get` is an alias because . doesn't work everywhere, e.g. you can't
pass it as an argument.
```

## ..
```
(.. foo.bar.baz)

Gets the value from a nested object where the argument is a period separated symbol.
```

## *
```
(* . numbers)

Multiplies all numbers passed as arguments. If single value is passed
it will return that value.
```

## **
```
(** a b)

Function that calculates number a to to the power of b.
```

## /
```
(/ n1 n2 ...)
(/ n)

Divides n1 by n2 and subsequent arguments one by one. If single argument
is passed it will calculate (/ 1 n).
```

## &
```
(& a b)

Function that calculates the bitwise and operation.
```

## +
```
(+ . numbers)

Sums all numbers passed as arguments. If single value is passed it will
return that value.
```

## <
```
(< x1 x2 ...)

Function that compares its numerical arguments and checks if they are
monotonically increasing, i.e. x1 < x2 and x2 < x3 and so on.
```

## <<
```
(<< a b)

Function that left shifts the value a by value b bits.
```

## <=
```
(<= x1 x2 ...)

Function that compares its numerical arguments and checks if they are
monotonically nondecreasing, i.e. x1 <= x2 and x2 <= x3 and so on.
```

## =
```
(== x1 x2 ...)}

Function that compares its numerical arguments and checks if they are
all equal.
```

## ==
```
(== x1 x2 ...)}

Function that compares its numerical arguments and checks if they are
all equal.
```

## >
```
(> x1 x2 x3 ...)

Function that compares its numerical arguments and checks if they are
monotonically decreasing, i.e. x1 > x2 and x2 > x3 and so on.
```

## >=
```
(>= x1 x2 ...)

Function that compares its numerical arguments and checks if they are
monotonically nonincreasing, i.e. x1 >= x2 and x2 >= x3 and so on.
```

## >>
```
(>> a b)

Function that right shifts the value a by value b bits.
```

## |
```
(| a b)

Function that calculates the bitwise or operation.
```

## ~
```
(~ number)

Function that calculates the bitwise inverse (flip all the bits).
```

## 1-
```
(1- number)

Function that subtracts 1 from the number and return result.
```

## 1+
```
(1+ number)

Function that adds 1 to the number and return result.
```

## abs
```
(abs number)

Function that returns the absolute value (magnitude) of number.
```

## alist->assign
```
(alist->assign alist . list-of-alists)

Function that works like Object.assign but for LIPS alists.
```

## alist->object
```
(alist->object alist)

Function that converts alist pairs to a JavaScript object.
```

## always
```
(always constant)

Higher-order function that returns a new thunk that always returns
the given constant when called.
```

## and
```
(and . expressions)

Macro that evaluates each expression in sequence and if any value returns false
it will stop and return false. If each value returns true it will return the
last value. If it's called without arguments it will return true.
```

## angle
```
(angle x)

Returns angle of the complex number in polar coordinate system.
```

## append
```
(append item ...)

Function that creates a new list with each argument appended end-to-end.
It will always return a new list and not modify its arguments.
```

## append!
```
(append! arg1 ...)

Destructive version of append, it can modify the lists in place. It returns
a new list where each argument is appended to the end. It may modify
lists added as arguments.
```

## apply
```
(apply fn list)

Function that calls fn with the list of arguments.
```

## apropos
```
(apropos name)

Search the current environment and display names that match the given name.
name can be regex, string or symbol.
```

## array->list
```
(array->list array)

Function that converts a JavaScript array to a LIPS cons list.
```

## array?
```
(array? expression)

Predicate that tests if value is an array.
```

## assoc
```
(assoc obj alist)

Returns pair from alist that match given key using equal? check.
```

## assq
```
(assq obj alist)

Returns pair from a list that matches given key using eq? check.
```

## assv
```
(assv obj alist)

Returns pair from alist that match given key using eqv? check.
```

## atan
```
(atan z)
(atan x y)

Function calculates arcus tangent of a complex number.
If two arguments are passed and they are not complex numbers
it calculate Math.atan2 on those arguments.
```

## await
```
(await value)

Unquotes a quoted promise so it can be automagically evaluated (resolved
to its value).
```

## begin
```
(begin . args)

Macro that runs a list of expressions in order and returns the value
of the last one. It can be used in places where you can only have a
single expression, like (if).
```

## begin*
```
(begin* . body)

This macro is a parallel version of begin. It evaluates each expression
in the body and if it's a promise it will await it in parallel and return
the value of the last expression (i.e. it uses Promise.all()).
```

## binary
```
(binary fn)

Returns a new function with arguments limited to two.
```

## binary-port?
```
(binary-port? port)

Function that tests if argument is binary port.
```

## boolean?
```
(boolean? x)

Returns true if value is boolean.
```

## boolean=?
```
(boolean=? b1 b2 ...)

Checks if all arguments are boolean and if they are the same.
```

## bound?
```
(bound? x [env])

Function that check if the variable is defined in the given environment,
or interaction-environment if not specified.
```

## buffer->u8vector
```
(buffer->u8vector bin)

Cross platform function that can be used in both Node and browser.
It can be used together with %read-file or %read-binary-file to convert
the result ArrayBuffer or Buffer to u8vector.
```

## bytevector
```
(u8vector v1 v2 ...)

Create unsigned 8-bit integer vector (C unsigned char) from give arguments.
```

## bytevector-append
```
(bytevector-append v1 ...)

Create new bytevector u8vector that is created from joining each argument.
```

## bytevector-copy
```
(bytevector-copy v)
(bytevector-copy v start)
(bytevector-copy v start end)

Returns a new vector from start to end. If no start and end is provided
whole vector is copied and returned.
```

## bytevector-copy!
```
(bytevector-copy! to at from)
(bytevector-copy! to at from start)
(bytevector-copy! to at from start end)

Copies the bytes of bytevector from between start and end to bytevector to,
starting at at.
```

## bytevector-length
```
(u8vector-length v)

return length of unsigned 8-bit integer vector (C unsigned char).
```

## bytevector-u8-ref
```
(u8vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## bytevector-u8-set!
```
(u8vector-set! vector k)

Function set value of unsigned 8-bit integer vector (C unsigned char) at index k.
If index is out of range it throw exception.
```

## bytevector?
```
(u8vector? x)

Returns #t of argument is unsigned 8-bit integer vector (C unsigned char),
otherwise it return #f.
```

## caaaaar
```
(caaaaar arg)

Function that calculates (car (car (car (car (car arg)))))
```

## caaaadr
```
(caaaadr arg)

Function that calculates (car (car (car (car (cdr arg)))))
```

## caaaar
```
(caaaar arg)

Function that calculates (car (car (car (car arg))))
```

## caaadar
```
(caaadar arg)

Function that calculates (car (car (car (cdr (car arg)))))
```

## caaaddr
```
(caaaddr arg)

Function that calculates (car (car (car (cdr (cdr arg)))))
```

## caaadr
```
(caaadr arg)

Function that calculates (car (car (car (cdr arg))))
```

## caaar
```
(caaar arg)

Function that calculates (car (car (car arg)))
```

## caadaar
```
(caadaar arg)

Function that calculates (car (car (cdr (car (car arg)))))
```

## caadadr
```
(caadadr arg)

Function that calculates (car (car (cdr (car (cdr arg)))))
```

## caadar
```
(caadar arg)

Function that calculates (car (car (cdr (car arg))))
```

## caaddar
```
(caaddar arg)

Function that calculates (car (car (cdr (cdr (car arg)))))
```

## caadddr
```
(caadddr arg)

Function that calculates (car (car (cdr (cdr (cdr arg)))))
```

## caaddr
```
(caaddr arg)

Function that calculates (car (car (cdr (cdr arg))))
```

## caadr
```
(caadr arg)

Function that calculates (car (car (cdr arg)))
```

## caar
```
(caar arg)

Function that calculates (car (car arg))
```

## cadaaar
```
(cadaaar arg)

Function that calculates (car (cdr (car (car (car arg)))))
```

## cadaadr
```
(cadaadr arg)

Function that calculates (car (cdr (car (car (cdr arg)))))
```

## cadaar
```
(cadaar arg)

Function that calculates (car (cdr (car (car arg))))
```

## cadadar
```
(cadadar arg)

Function that calculates (car (cdr (car (cdr (car arg)))))
```

## cadaddr
```
(cadaddr arg)

Function that calculates (car (cdr (car (cdr (cdr arg)))))
```

## cadadr
```
(cadadr arg)

Function that calculates (car (cdr (car (cdr arg))))
```

## cadar
```
(cadar arg)

Function that calculates (car (cdr (car arg)))
```

## caddaar
```
(caddaar arg)

Function that calculates (car (cdr (cdr (car (car arg)))))
```

## caddadr
```
(caddadr arg)

Function that calculates (car (cdr (cdr (car (cdr arg)))))
```

## caddar
```
(caddar arg)

Function that calculates (car (cdr (cdr (car arg))))
```

## cadddar
```
(cadddar arg)

Function that calculates (car (cdr (cdr (cdr (car arg)))))
```

## caddddr
```
(caddddr arg)

Function that calculates (car (cdr (cdr (cdr (cdr arg)))))
```

## cadddr
```
(cadddr arg)

Function that calculates (car (cdr (cdr (cdr arg))))
```

## caddr
```
(caddr arg)

Function that calculates (car (cdr (cdr arg)))
```

## cadr
```
(cadr arg)

Function that calculates (car (cdr arg))
```

## call-with-current-continuation
```
(call/cc proc)

Call-with-current-continuation.

NOT SUPPORTED BY LIPS RIGHT NOW
```

## call-with-input-file
```
(call-with-input-file filename proc)

Procedure open file for reading, call user defined procedure with given port
and then close the port. It return value that was returned by user proc
and it close the port even if user proc throw exception.
```

## call-with-output-file
```
(call-with-output-file filename proc)

Procedure open file for writing, call user defined procedure with port
and then close the port. It return value that was returned by user proc
and it close the port even if user proc throw exception.
```

## call-with-port
```
(call-with-port port proc)

Proc is executed with given port and after it returns, the port is closed.
```

## call-with-values
```
(call-with-values producer consumer)

Calls the producer procedure with no arguments, then calls the
consumer procedure with the returned value as an argument -- unless
the returned value is a special Values object created by (values), if it is
the values are unpacked and the consumer is called with multiple arguments.
```

## call/cc
```
(call/cc proc)

Call-with-current-continuation.

NOT SUPPORTED BY LIPS RIGHT NOW
```

## car
```
(car pair)

This function returns the car (item 1) of the list.
```

## cdaaaar
```
(cdaaaar arg)

Function that calculates (cdr (car (car (car (car arg)))))
```

## cdaaadr
```
(cdaaadr arg)

Function that calculates (cdr (car (car (car (cdr arg)))))
```

## cdaaar
```
(cdaaar arg)

Function that calculates (cdr (car (car (car arg))))
```

## cdaadar
```
(cdaadar arg)

Function that calculates (cdr (car (car (cdr (car arg)))))
```

## cdaaddr
```
(cdaaddr arg)

Function that calculates (cdr (car (car (cdr (cdr arg)))))
```

## cdaadr
```
(cdaadr arg)

Function that calculates (cdr (car (car (cdr arg))))
```

## cdaar
```
(cdaar arg)

Function that calculates (cdr (car (car arg)))
```

## cdadaar
```
(cdadaar arg)

Function that calculates (cdr (car (cdr (car (car arg)))))
```

## cdadadr
```
(cdadadr arg)

Function that calculates (cdr (car (cdr (car (cdr arg)))))
```

## cdadar
```
(cdadar arg)

Function that calculates (cdr (car (cdr (car arg))))
```

## cdaddar
```
(cdaddar arg)

Function that calculates (cdr (car (cdr (cdr (car arg)))))
```

## cdadddr
```
(cdadddr arg)

Function that calculates (cdr (car (cdr (cdr (cdr arg)))))
```

## cdaddr
```
(cdaddr arg)

Function that calculates (cdr (car (cdr (cdr arg))))
```

## cdadr
```
(cdadr arg)

Function that calculates (cdr (car (cdr arg)))
```

## cdar
```
(cdar arg)

Function that calculates (cdr (car arg))
```

## cddaaar
```
(cddaaar arg)

Function that calculates (cdr (cdr (car (car (car arg)))))
```

## cddaadr
```
(cddaadr arg)

Function that calculates (cdr (cdr (car (car (cdr arg)))))
```

## cddaar
```
(cddaar arg)

Function that calculates (cdr (cdr (car (car arg))))
```

## cddadar
```
(cddadar arg)

Function that calculates (cdr (cdr (car (cdr (car arg)))))
```

## cddaddr
```
(cddaddr arg)

Function that calculates (cdr (cdr (car (cdr (cdr arg)))))
```

## cddadr
```
(cddadr arg)

Function that calculates (cdr (cdr (car (cdr arg))))
```

## cddar
```
(cddar arg)

Function that calculates (cdr (cdr (car arg)))
```

## cdddaar
```
(cdddaar arg)

Function that calculates (cdr (cdr (cdr (car (car arg)))))
```

## cdddadr
```
(cdddadr arg)

Function that calculates (cdr (cdr (cdr (car (cdr arg)))))
```

## cdddar
```
(cdddar arg)

Function that calculates (cdr (cdr (cdr (car arg))))
```

## cddddar
```
(cddddar arg)

Function that calculates (cdr (cdr (cdr (cdr (car arg)))))
```

## cdddddr
```
(cdddddr arg)

Function that calculates (cdr (cdr (cdr (cdr (cdr arg)))))
```

## cddddr
```
(cddddr arg)

Function that calculates (cdr (cdr (cdr (cdr arg))))
```

## cdddr
```
(cdddr arg)

Function that calculates (cdr (cdr (cdr arg)))
```

## cddr
```
(cddr arg)

Function that calculates (cdr (cdr arg))
```

## cdr
```
(cdr pair)

This function returns the cdr (all but first) of the list.
```

## ceiling
```
(ceiling number)

Function that calculates the ceiling of a number.
```

## char->integer
```
(char->integer chr)

Returns the codepoint of Unicode character.
```

## char-alphabetic?
```
(char-alphabetic? chr)

Returns true if character is leter of the ASCII alphabet.
```

## char-ci<?
```
(char-ci<? chr1 chr2)

Returns true if characters are monotonically increasing case insensitive.
```

## char-ci<=?
```
(char-ci<? chr1 chr2 ...)

Returns true if characters are monotonically non-decreasing, case insensitive.
```

## char-ci=?
```
(char-ci=? chr1 chr2 ...)

Checks if all characters are equal, case insensitive.
```

## char-ci>?
```
(char-ci<? chr1 chr2 ...)

Returns true if characters are monotonically decreasing case insensitive.
```

## char-ci>=?
```
(char-ci<? chr1 chr2 ...)

Returns true if characters are monotonically non-increasing, case insensitive.
```

## char-downcase
```
(char-downcase chr)

Create lowercase version of the character.
```

## char-foldcase
```
(char-foldcase char)

Returns lowercase character using the Unicode simple case-folding algorithm.
```

## char-lower-case?
```
(char-upper-case? char)

Checks if character is lower case.
```

## char-numeric?
```
(char-numeric? chr)

Returns true if character is number.
```

## char-ready?
```
(char-ready?)
(char-ready? port)

Checks if characters is ready in input port. This is useful mostly
for interactive ports that return false if it would wait for user input.
It return false if port is closed.
```

## char-upcase
```
(char-upcase char)

Create uppercase version of the character.
```

## char-upper-case?
```
(char-upper-case? char)

Checks if character is upper case.
```

## char-whitespace?
```
(char-whitespace? chr)

Returns true if character is whitespace.
```

## char?
```
(char? obj)

Checks if the object is a character.
```

## char<?
```
(char<? chr1 chr2 ...)

Returns true if characters are monotonically increasing.
```

## char<=?
```
(char<? chr1 chr2 ...)

Returns true if characters are monotonically non-decreasing.
```

## char=?
```
(char=? chr1 chr2 ...)

Checks if all characters are equal.
```

## char>?
```
(char<? chr1 chr2 ...)

Returns true if characters are monotonically decreasing.
```

## char>=?
```
(char<? chr1 chr2 ...)

Returns true if characters are monotonically non-increasing.
```

## clone
```
(clone list)

Function that returns a clone of the list, that does not share any pairs with the
original, so the clone can be safely mutated without affecting the original.
```

## close-input-port
```
(close-input-port port)

Procedure close port that was opened with open-input-file. After that
it no longer accept reading from that port.
```

## close-output-port
```
(close-output-port port)

Procedure close port that was opened with open-output-file. After that
it no longer accept write to that port.
```

## close-port
```
(close-port port)

Close input or output port.
```

## command-line
```
(command-line)

Returns the command line arguments, or an empty list if not running under Node.js.
```

## complement
```
(complement fn)

Higher order function that returns the Boolean complement of the given function.
If the function fn for a given arguments return true the result function
will return false, if it would return false, the result function will return true.
```

## complex?
```
(complex? x)

Checks if argument x is complex.
```

## compose
```
(compose . fns)

Higher-order function that creates a new function that applies all functions
from right to left and returns the last value. Reverse of pipe.
e.g.:
((compose (curry + 2) (curry * 3)) 10) ==> (+ 2 (* 3 10)) ==> 32
```

## concat
```
(concat . strings)

Function that creates a new string by joining its arguments.
```

## cond
```
(cond (predicate? . body)
      (predicate? . body)
      (else . body))

(cond (predicate? => procedure)
      (predicate? => procedure)
      (else . body))

Macro for condition checks. For usage instead of nested ifs.
You can use predicate and any number of expressions. Or symbol =>
Followed by procedure that will be invoked with result
of the predicate.
```

## cons
```
(cons left right)

This function returns a new list with the first appended
before the second. If the second is not a list cons will
return a dotted pair.
```

## constructor
```
(constructor)

Function that is present in JavaScript environment. We define it in Scheme
to fix an issue with define-class. This function throw an error.
```

## continuation?
```
(continuation? expression)

Predicate that tests if value is a callable continuation.
```

## cos
```
(cos n)

Function that calculates cosine of a number.
```

## current-directory
```
(current-directory)

Returns the current working directory, default is the path from where
the script was executed.
```

## current-environment
```
(current-environment)

Function that returns the current environment (they're first-class objects!)
```

## current-error-port
```
(current-output-port)

Returns the default stderr port.
```

## current-input-port
```
(current-input-port)

Returns the default stdin port.
```

## current-jiffy
```
(current-jiffy)

Return current jiffy. In LIPS is jiffy since start of the process.
You can divide this value by (jiffies-per-second) to get seconds since
start of the process. And you can add %%start-jiffy to get jiffy since
January 1, 1970.
```

## current-output-port
```
(current-output-port)

Returns the default stdout port.
```

## current-second
```
(current-second)

Functionn return exact integer of the seconds since January 1, 1970
```

## curry
```
(curry fn . args)

Higher-order function that creates a curried version of the function.
The result function will have partially applied arguments and it
will keep returning one-argument functions until all arguments are provided,
then it calls the original function with the accumulated arguments.

e.g.:
(define (add a b c d) (+ a b c d))
(define add1 (curry add 1))
(define add12 (add 2))
(display (add12 3 4))
```

## debugger
```
(debugger)

Function that triggers the JavaScript debugger (e.g. the browser devtools)
using the "debugger;" statement. If a debugger is not running this
function does nothing.
```

## define
```
(define name expression)
(define name expression "doc string")
(define (function-name . args) . body)

Macro for defining values. It can be used to define variables,
or functions. If the first argument is list it will create a function
with name being first element of the list. This form expands to
`(define function-name (lambda args body))`
```

## define-class
```
(define-class name parent . body)

Defines a class - JavaScript function constructor with prototype.
parent needs to be class, constructor function, or #null

usage:

  (define-class Person Object
      (constructor (lambda (self name)
                     (set-object! self '_name name)))
      (hi (lambda (self)
            (display (string-append self._name " says hi"))
            (newline))))
  (define jack (new Person "Jack"))
  (jack.hi) ; prints "Jack says hi"
```

## define-formatter-rule
```
(rule-pattern pattern)

Anaphoric macro for defining patterns for the formatter.
With Ahead, Pattern and * defined values.
```

## define-global
```
(define-global var value)
(define-global (name . args) body)

Defines functions or variables in the global context, so they can be used
inside let and get let variables in a closure. Useful for universal macros.
```

## define-library
```
(define-library (library (name namespace) . body)

Macro for defining modules inside you can use define to create functions.
And use export name to add that name to defined environment.
```

## define-macro
```
(define-macro (name . args) body)

The meta-macro, that creates new macros. If the return value is a list structure
it will be evaluated where the macro is invoked from. You can use quasiquote `
and unquote , and unquote-splicing ,@ inside to create an expression that will be
evaluated at runtime. Macros works like this: if you pass any expression to a
macro the arguments will not be evaluated unless the macro's body explicitly
calls (eval) on it. Because of this a macro can manipulate the expression
(arguments) as lists.
```

## define-record-type
```
(define-record-type name constructor pred . fields)

Macro for defining records. Example of usage:

(define-record-type <pare>
  (kons x y)
  pare?
  (x kar set-kar!)
  (y kdr set-kdr!))

(define p (kons 1 2))
(print (kar p))
;; ==> 1
(set-kdr! p 3)
(print (kdr p))
;; ==> 3
```

## define-symbol-macro
```
(define-symbol-macro type (name . args) . body)

Creates syntax extensions for evaluator similar to built-in , or `.
It's like an alias for a real macro. Similar to CL reader macros
but it receives already parsed code like normal macros. Type can be SPLICE
or LITERAL symbols (see set-special!). ALL default symbol macros are literal.
```

## define-syntax
```
(define-syntax name expression [__doc__])

Defines a new hygienic macro using syntax-rules with optional documentation.
```

## define-syntax-parameter
```
(define-syntax-parameter name syntax [__doc__])

Binds <keyword> to the transformer obtained by evaluating <transformer spec>.
The transformer provides the default expansion for the syntax parameter,
and in the absence of syntax-parameterize, is functionally equivalent to
define-syntax.
```

## defmacro?
```
(defmacro? expression)

Checks if object is a macro and it's expandable.
```

## degree->radians
```
(degree->radians x)

Convert degrees to radians.
```

## delay
```
(delay expression)

Will create a promise from expression that can be forced with (force).
```

## delete-file
```
(delete-file filename)

Deletes the file of given name.
```

## denominator
```
(denominator n)

Return denominator of rational or same number if one is not rational.
```

## digit-value
```
(digit-value chr)

Return digit number if character is numeral (as per char-numeric?)
or #f otherwise.
```

## dir
```
(dir obj)

Returns all props on the object including those in prototype chain.
```

## display
```
(display string [port])

This function outputs the string to the standard output or
the port if given. No newline.
```

## display-error
```
(display-error . args)

Display an error message on stderr.
```

## do
```
(do ((<var> <init> <next>)) (test return) . body)

Iteration macro that evaluates the expression body in scope of the variables.
On each loop it changes the variables according to the <next> expression and runs
test to check if the loop should continue. If test is a single value, the macro
will return undefined. If the test is a pair of expressions the macro will
evaluate and return the second expression after the loop exits.
```

## do-iterator
```
(do-iterator (var expr) (test result) body ...)

Iterates over iterators (e.g. created with JavaScript generator function)
that works with normal and async iterators. You can loop over an infinite
iterators and break the loop if you want, using expression like in do macro.
Long synchronous iterators will block the main thread (you can't print
1000 numbers from infinite iterators, because it will freeze the browser),
but if you use async iterators you can process the values as they are
generated.
```

## drop
```
(take list n)

Returns a list where first n elements are removed.
```

## dynamic-wind
```
(dynamic-wind before thunk after)

Accepts 3 procedures/lambdas and executes before, then thunk, and
always after even if an error occurs in thunk.
```

## empty?
```
(empty? object)

Function that returns #t if value is nil (an empty list) or undefined.
```

## env
```
(env)
(env obj)

Function that returns a list of names (functions, macros and variables)
that are bound in the current environment or one of its parents.
```

## environment-bound?
```
(environment-bound? env symbol)

Checks if symbol is a bound variable similar to bound?.
```

## environment?
```
(environment? obj)

Checks if object is a LIPS environment.
```

## eof-object
```
(eof-object)

Procedure returns eof object that indicate end of the port
```

## eof-object?
```
(eof-object? arg)

Checks if value is eof object, returned from input string
port when there are no more data to read.
```

## eq?
```
(eq? a b)

Function that compares two values if they are identical.
```

## equal?
```
(equal? a b)

The function checks if values are equal. If both are a pair or an array
it compares their elements recursively. If pairs have cycles it compares
them with eq?
```

## eqv?
```
(eqv? a b)

Function that compares the values. It returns true if they are the same, they
need to have the same type.
```

## error
```
(error message ...)

Function raises error with given message and arguments,
which are called invariants.
```

## error-object-irritants
```
(error-object-irritants error-object)

Returns a list of the irritants encapsulated by error-object.
```

## error-object-message
```
(error-object-message error-object)

Returns the message encapsulated by error-object.
```

## error-object?
```
(error-object? obj)

Checks if object is of Error object thrown by error function.
```

## escape-regex
```
(escape-regex string)

Function that returns a new string where all special operators used in regex,
are escaped with backslashes so they can be used in the RegExp constructor
to match a literal string.
```

## eval
```
(eval expr)
(eval expr environment)

Function that evaluates LIPS Scheme code. If the second argument is provided
it will be the environment that the code is evaluated in.
```

## even?
```
(even? number)

Checks if number is even.
```

## every
```
(every fn . lists)

Higher-order function that calls fn on consecutive item of the list of lists,
if every call returns true it will return true otherwise it return false.
Analogous to Python all(map(fn, list)).
```

## exact
```
(inexact->exact number)

Function that converts real number to exact rational number.
```

## exact->inexact
```
(exact->inexact n)

Convert exact number to inexact.
```

## exact-integer?
```
(exact-integer? n)

Returns #t if z is both exact and an integer; otherwise
returns #f.
```

## exact?
```
(exact? n)
```

## exp
```
(exp n)

Function that calculates e raised to the power of n.
```

## expt
```
(** a b)

Function that calculates number a to to the power of b.
```

## f32vector
```
(f32vector v1 v2 ...)

Create 32-bit IEEE-754 floating point number vector (C float) from give arguments.
```

## f32vector-length
```
(f32vector-length v)

return length of 32-bit IEEE-754 floating point number vector (C float).
```

## f32vector-ref
```
(f32vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## f32vector-set!
```
(f32vector-set! vector k)

Function set value of 32-bit IEEE-754 floating point number vector (C float) at index k.
If index is out of range it throw exception.
```

## f32vector?
```
(f32vector? x)

Returns #t of argument is 32-bit IEEE-754 floating point number vector (C float),
otherwise it return #f.
```

## f64vector
```
(f64vector v1 v2 ...)

Create 64-bit IEEE-754 floating point number vector (C double) from give arguments.
```

## f64vector-length
```
(f64vector-length v)

return length of 64-bit IEEE-754 floating point number vector (C double).
```

## f64vector-ref
```
(f64vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## f64vector-set!
```
(f64vector-set! vector k)

Function set value of 64-bit IEEE-754 floating point number vector (C double) at index k.
If index is out of range it throw exception.
```

## f64vector?
```
(f64vector? x)

Returns #t of argument is 64-bit IEEE-754 floating point number vector (C double),
otherwise it return #f.
```

## features
```
(features)

Function returns implemented features as a list.
```

## filter
```
(filter fn list)
(filter regex list)

Higher-order function that calls `fn` for each element of the list
and return a new list for only those elements for which fn returns
a truthy value. If called with a regex it will create a matcher function.
```

## find
```
(find fn list)
(find regex list)
(find atom list)

Higher-order function that finds the first value for which fn return true.
If called with a regex or any atom it will create a matcher function.
```

## finite?
```
(finite? x)

Checks if value is finite.
```

## flatten
```
(flatten list)

Returns a shallow list from tree structure (pairs).
```

## flip
```
(flip fn)

Higher-order function that returns a new function where the first two arguments
are swapped.

Example:

  (define first (curry (flip vector-ref) 0))
  (first #(1 2 3))
  ;; ==> 1
```

## floor
```
(floor number)

Function that calculates the floor of a number.
```

## flush-output
```
(flush-output [port])

If output-port is buffered, this causes the contents of its buffer to be written to
the output device. Otherwise it has no effect. Returns an unspecified value.
```

## flush-output-port
```
(flush-output-port port)

Function do nothing, flush is not needed in LIPS in both NodeJS and Browser.
The function is added, so it don't throw exception when using R7RS code.
```

## fold
```
(fold fn init . lists)

Function fold is left-to-right reversal of reduce. It call `fn`
on each pair of elements of the list and returns a single value.
e.g. it computes (fn 'a 'x (fn 'b 'y (fn 'c 'z 'foo)))
for: (fold fn 'foo '(a b c) '(x y z))
```

## fold-left
```
(fold fn init . lists)

Function fold is left-to-right reversal of reduce. It call `fn`
on each pair of elements of the list and returns a single value.
e.g. it computes (fn 'a 'x (fn 'b 'y (fn 'c 'z 'foo)))
for: (fold fn 'foo '(a b c) '(x y z))
```

## fold-right
```
(reduce fn init list . lists)

Higher-order function that takes each element of the list and calls
the fn with result of previous call or init and the next element
of the list until each element is processed, and returns a single value
as result of last call to `fn` function.
e.g. it computes (fn 'c 'z (fn 'b 'y (fn 'a 'x 'foo)))
for: (reduce fn 'foo '(a b c) '(x y z))
```

## for-each
```
(for-each fn . lists)

Higher-order function that calls function `fn` on each
value of the argument. If you provide more than one list
it will take each value from each list and call `fn` function
with that many arguments as number of list arguments.
```

## force
```
(force promise)

Function that forces the promise and evaluates the delayed expression.
```

## format
```
(format string n1 n2 ...)

This function accepts a string template and replaces any
escape sequences in its inputs:

* ~a value as if printed with `display`
* ~s value as if printed with `write`
* ~% newline character
* ~~ literal tilde '~'

If there are missing inputs or other escape characters it
will error.
```

## freeze-list!
```
(freeze-list! list)

Function make the whole list read only. It mutates the list and returns #void.
```

## freeze-prop!
```
(freeze-prop! object property)

Function make an object property read only.
```

## function?
```
(function? expression)

Predicate that tests if value is a callable function.
```

## gcd
```
(gcd n1 n2 ...)

Function that returns the greatest common divisor of the arguments.
```

## gensym
```
(gensym)

Generates a unique symbol that is not bound anywhere,
to use with macros as meta name.
```

## gensym-literal
```
(gensym-literal symbol)

Parser extension that creates a new quoted named gensym.
```

## gensym?
```
(gensym? value)

Returns #t if value is a symbol created by gensym. It returns #f otherwise.
```

## get
```
(. obj . args)
(get obj . args)

This function uses an object as a base and keeps using arguments to get the
property of JavaScript object. Arguments need to be a strings.
e.g. `(. console "log")` if you use any function inside LIPS it
will be weakly bound (can be rebound), so you can call this log function
without problem unlike in JavaScript when you use
`var log = console.log`.
`get` is an alias because . doesn't work everywhere, e.g. you can't
pass it as an argument.
```

## get-environment-variable
```
(get-environment-variable name)

Returns given environment variable. This function returns #void
when called in the browser.
```

## get-environment-variables
```
(get-environment-variables)

Returns all process environment variables as an alist. This function returns
an empty list when called in the browser.
```

## get-output-bytevector
```
(get-output-string port)

Gets full string from string port. If nothing was wrote
to given port it will return empty string.
```

## get-output-string
```
(get-output-string port)

Gets full string from string port. If nothing was wrote
to given port it will return empty string.
```

## get-resource
```
(get-resource url)

Load JavaScript or CSS file in browser by adding script/link tag to head
of the current document. When called from Node it allow it allows to load
JavaScript files only.
```

## globalize
```
(globalize expr)

 Macro will get the value of the expression and add each method as function
 to global scope.
```

## help
```
(help object)

This macro returns documentation for a function, macro, or a variable.
```

## http-get
```
(http-get url)

Node.js function that sends a HTTP Request and returns a string or
binary Buffer object.
```

## identity
```
(identity n)

No-op function. It just returns its argument.
```

## if
```
(if cond true-expr false-expr)

Macro that evaluates cond expression and if the value is true, it
evaluates and returns true-expression, if not it evaluates and returns
false-expression.
```

## ignore
```
(ignore . body)

Macro that will evaluate the expression and swallow any promises that may
be created. It will discard any value that may be returned by the last body
expression. The code should have side effects and/or when it's promise
it should resolve to undefined.
```

## imag-part
```
(imag-part n)

Return imaginary part of the complex number n.
```

## import
```
(import (library namespace))
(import (only (library namespace) name1 name2))

Macro for importing names from library.
```

## in
```
(in key value)

Function that uses the Javascript "in" operator to check if key is
a valid property in the value.
```

## include
```
(include file ...)

Load at least one file content and insert them into one,
body expression.
```

## indexed-db?
```
(indexed-db?)

Function that tests if IndexedDB is available.
```

## inexact
```
(exact->inexact n)

Convert exact number to inexact.
```

## inexact->exact
```
(inexact->exact number)

Function that converts real number to exact rational number.
```

## inexact?
```
(inexact? n)
```

## infinite?
```
(infinite? x)

Checks if value is infinite.
```

## input-port-open?
```
(input-port-open? port)

Checks if argument is input-port and if you can read from it.
```

## input-port?
```
(input-port? arg)

Returns true if argument is input port.
```

## inspect
```
(inspect object)

logs the arguments without unboxing.
```

## instance?
```
(instance? obj)

Checks if object is an instance, created with a new operator
```

## instanceof
```
(instanceof type obj)

Predicate that tests if the obj is an instance of type.
```

## integer->char
```
(integer->char chr)

Function that converts number argument to character.
```

## integer?
```
(integer? x)

Checks if the argument x is integer.
```

## interaction-environment
```
(interaction-environment)

Returns the interaction environment equal to lips.env. This can be overwritten
when creating new interpreter with lips.Interpreter.
```

## is-debug
```
(is-debug)
(is-debug value)

Debug function, which checks if internal debug state is set to
a given value or true.
```

## iterator->array
```
(iterator->array object)

Return array from JavaScript iterator object.
```

## iterator?
```
(iterator? x)

 Checks if value is JavaScript iterator object.
```

## join
```
(join separator list)

Function that returns a string by joining elements of the list using separator.
```

## key->string
```
(key->string symbol)

If symbol is a keyword it converts that to string and removes the colon.
```

## key?
```
(key? symbol)

Checks if symbol is a keyword (has a colon as first character).
```

## lambda
```
(lambda (a b) body)
(lambda args body)
(lambda (a b . rest) body)

The lambda macro creates a new anonymous function. If the first element of
the body is a string and there is more elements the string is used as the
documentation string, that can be read using (help fn).
```

## lcm
```
(lcm n1 n2 ...)

Function that returns the least common multiple of the arguments.
```

## length
```
(length expression)

Function that returns the length of the object. The object can be a LIPS
list or any object that has a "length" property. Returns undefined if the
length could not be found.
```

## let
```
(let ((a value-a) (b value-b) ...) . body)

Macro that creates a new environment, then evaluates and assigns values to names,
and then evaluates the body in context of that environment.  Values are evaluated
sequentially but you can't access previous values/names when the next are
evaluated. You can only get them in the body of the let expression.  (If you want
to define multiple variables and use them in each other's definitions, use
`let*`.)
```

## let-env
```
(let-env env . body)

Special macro that evaluates body in context of given environment
object.
```

## let-env-values
```
(let-env-values env ((name var)) . body)

Adds mappings for variables var from specified env.
it is similar to let-env but lexical scope is working with it.
```

## let-syntax
```
(let-syntax ((name fn) ...) . body)

 Works like a combination of let and define-syntax. It creates
 local macros and evaluates body in context of those macros.
 The macro to letrec-syntax is like letrec is to let.
```

## let*
```
(let* ((a value-a) (b value-b) ...) . body)

Macro similar to `let`, but the subsequent bindings after the first
are evaluated in the environment including the previous let variables,
so you can define one variable, and use it in the next's definition.
```

## letrec
```
(letrec ((a value-a) (b value-b) ...) . body)

Macro that creates a new environment, then evaluates and assigns values to
names and then evaluates the body in context of that environment.
Values are evaluated sequentially and the next value can access the
previous values/names.
```

## letrec-syntax
```
(letrec-syntax ((name fn) ...) . body)

 Works like a combination of letrec and define-syntax. It creates
 local macros and evaluates the body in context of those macros.
```

## letrec*
```
(letrec* ((a value-a) (b value-b) ...) . body)

Same as letrec but the order of execution of the binding is guaranteed,
so you can use recursive code as well as referencing the previous binding.

In LIPS both letrec and letrec* behave the same.
```

## list
```
(list . args)

Function that creates a new list out of its arguments.
```

## list->array
```
(list->array list)

Function that converts a LIPS list into a JavaScript array.
```

## list->string
```
(list->string _list)

Returns a string from a list of characters.
```

## list->vector
```
(list->array list)

Function that converts a LIPS list into a JavaScript array.
```

## list-copy
```
(list-copy obj)

Copy the object passed as argument but only if it's list. The car elements
of the list are not copied, they are passed as is.
```

## list-match?
```
(list-match? predicate list)

Checks if consecutive elements of the list match the predicate function.
```

## list-ref
```
(list-ref list n)

Returns n-th element of a list.
```

## list-set!
```
(list-set! list n)

Returns n-th element of a list.
```

## list-tail
```
(list-tail list k)

Returns the sublist of list obtained by omitting the first k elements.
```

## list?
```
(list? obj)

Predicate that tests if value is a proper linked list structure.
The car of each pair can be any value. It returns false on cyclic lists."
```

## list*
```
(list* arg1 ...)

Parallel asynchronous version of list. Like begin* except all values
are returned in a list.
```

## load
```
(load filename)
(load filename environment)

Fetches the file (from disk or network) and evaluates its content as LIPS code.
If the second argument is provided and it's an environment the evaluation
will happen in that environment.
```

## log
```
(log z)
(log z1 z2)

Function that calculates natural logarithm (base e) of z. Where the argument
can be any number (including complex negative and rational). If the value is 0
it returns NaN. It two arguments are provided it will calculate logarithm
of z1 with given base z2.
```

## macro?
```
(macro? expression)

Predicate that tests if value is a macro.
```

## macroexpand
```
(macroexpand expr)

Macro that expand all macros inside and return single expression as output.
```

## macroexpand-1
```
(macroexpand-1 expr)

Macro similar to macroexpand but it expand macros only one level
and return single expression as output.
```

## magnitude
```
(magnitude x)

Returns magnitude of the complex number in polar coordinate system.
```

## make-bytevector
```
(make-u8vector k fill)

Allocate new unsigned 8-bit integer vector (C unsigned char) of length k,
with optional initial values.
```

## make-f32vector
```
(make-f32vector k fill)

Allocate new 32-bit IEEE-754 floating point number vector (C float) of length k,
with optional initial values.
```

## make-f64vector
```
(make-f64vector k fill)

Allocate new 64-bit IEEE-754 floating point number vector (C double) of length k,
with optional initial values.
```

## make-parameter
```
(make-parameter init converter)

Function creates new dynamic variable that can be custimized with parameterize
macro. The value should be assigned to a variable e.g.:

(define radix (make-parameter 10))

The result value is a procedure that return the value of dynamic variable.
```

## make-polar
```
(make-polar magnitude angle)

Create new complex number from polar parameters.
```

## make-promise
```
(make-promise fn)

Function that creates a promise from a function.
```

## make-rectangular
```
(make-rectangular re im)

Creates a complex number from imaginary and real part (a+bi form).
```

## make-s16vector
```
(make-s16vector k fill)

Allocate new signed 16-bit integer vector (C short) of length k,
with optional initial values.
```

## make-s32vector
```
(make-s32vector k fill)

Allocate new signed 32-bit integer vector (C unsigned int) of length k,
with optional initial values.
```

## make-s8vector
```
(make-s8vector k fill)

Allocate new signed 8-bit integer vector (C signed char) of length k,
with optional initial values.
```

## make-string
```
(make-string k [char])

Returns new string with k elements. If char is provided
it's filled with that character.
```

## make-tags
```
(make-tags expression)

Returns a list structure of code with better syntax then raw LIPS
```

## make-u16vector
```
(make-u16vector k fill)

Allocate new unsigned 16-bit integer vector (C unsigned short) of length k,
with optional initial values.
```

## make-u32vector
```
(make-u32vector k fill)

Allocate new unsigned 32-bit integer vector (C int) of length k,
with optional initial values.
```

## make-u8vector
```
(make-u8vector k fill)

Allocate new unsigned 8-bit integer vector (C unsigned char) of length k,
with optional initial values.
```

## make-vector
```
(make-vector n [fill])

Creates a new vector with n empty elements. If fill is specified it will set
all elements of the vector to that value.
```

## map
```
(map fn . lists)

Higher-order function that calls function `fn` with each
value of the list. If you provide more then one list as argument
it will take each value from each list and call `fn` function
with that many argument as number of list arguments. The return
values of the fn calls are accumulated in a result list and
returned by map.
```

## match
```
(match pattern string)

Function that returns a match object from JavaScript as a list or #f if
no match.
```

## max
```
(max n1 n2 ...)

Returns the maximum of its arguments.
```

## member
```
(member obj list)

Returns first object in the list that match using equal? function.
```

## memq
```
(memq obj list)

Returns first object in the list that match using eq? function.
```

## memv
```
(memv obj list)

Returns first object in the list that match using eqv? function.
```

## min
```
(min n1 n2 ...)

Returns the minimum of its arguments.
```

## modulo
```
(modulo a b)

Returns modulo operation on its argumennts.
```

## n-ary
```
(n-ary n fn)

Returns a new function that limits the number of arguments to n.
```

## nan?
```
(nan? x)

Checks if argument x is Not a Number (NaN) value.
```

## native-symbol?
```
(native-symbol? object)

Checks if value is JavaScript Symbol.
```

## native.number
```
(native.number obj)

If argument is a number it will convert it to a native number.
```

## negative?
```
(negative? x)

Checks if the number is smaller then 0
```

## new
```
(new obj . args)

Function that creates new JavaScript instance of an object.
```

## new-library
```
(new-library name)

Create new empty library object with empty namespace.
```

## newline
```
(newline [port])

Write newline character to standard output or given port
```

## not
```
(not x)

Returns true if value is false and false otherwise.
```

## nth
```
(nth index obj)

Function that returns the nth element of the list or array.
If used with a non-indexable value it will error.
```

## nth-pair
```
(nth-pair list n)

Returns nth pair of a list.
```

## null-environment
```
(null-environment)

Returns a clean environment with only the standard library.
```

## null?
```
(null? expression)

Predicate that tests if value is null-ish (i.e. undefined, nil, or
Javascript null).
```

## number->string
```
(number->string x [radix])

Function that converts number to string with optional radix (number base).
```

## number?
```
(number? expression)

Predicate that tests if value is a number or NaN value.
```

## numerator
```
(numerator n)

Return numerator of rational or same number if n is not rational.
```

## object
```
(object :name value)

Creates a JavaScript object using key like syntax.
```

## object->alist
```
(object->alist object)

Function that converts a JavaScript object to Alist
```

## object?
```
(object? expression)

Predicate that tests if value is an plain object (not another LIPS type).
```

## odd?
```
(odd? number)

Checks if number is odd.
```

## once
```
(once fn)

Higher-order function that returns a new function, that only calls the original
on the first invocation, and immediately returns the first call's result again
on subsequent invocations.
```

## open-binary-input-file
```
(open-binary-input-file filename)

Returns new Input Binary Port with given filename. In Browser
user need to provide global fs variable that is instance of FS interface.
```

## open-binary-output-file
```
(open-binary-output-file filename)

Opens file and return port that can be used for writing. If file
exists it will throw an Error.
```

## open-input-bytevector
```
(open-input-bytevector bytevector)

Create new input binary port with given bytevector
```

## open-input-file
```
(open-input-file filename)

Returns new Input Port with given filename. In Browser user need to
provide global fs variable that is instance of FS interface.
```

## open-input-string
```
(open-input-string string)

Creates new string port as input that can be used to
read S-exressions from this port using `read` function.
```

## open-output-bytevector
```
(open-output-bytevector)

Create new output port that can be used to write binary data.
After done with the data the output buffer can be obtained by calling
`get-output-bytevector` function.
```

## open-output-file
```
(open-output-file filename)

Function that opens file and return port that can be used for writing. If file
exists it will throw an Error.
```

## open-output-string
```
(open-output-string)

Creates new output port that can used to write string into
and after finish get the whole string using `get-output-string`.
```

## or
```
(or . expressions)

Macro that executes the values one by one and returns the first that is
a truthy value. If there are no expressions that evaluate to true it
returns false.
```

## output-port-open?
```
(output-port-open? port)

Checks if argument is output-port and if you can write to it.
```

## output-port?
```
(output-port? arg)

Returns true if argument is output port.
```

## pair-map
```
(pair-map fn list)

Function that calls fn argument for pairs in a list and returns a combined list
with values returned from function fn. It works likes map but take two items
from the list each time.
```

## pair?
```
(pair? expression)

Predicate that tests if value is a pair or list structure.
```

## parameterize
```
(parameterize ((name value) ...)

Macro that change the dynamic variable created by make-parameter.
```

## parent.frame
```
(parent.frame)

Returns the parent environment if called from inside a function.
If no parent frame can be found it returns nil.
```

## parent.frames
```
(parent.frames)

Returns the list of environments from parent frames (lambda function calls)
```

## peek-char
```
(peek-char port)

This function reads and returns a character from the string
port, or, if there is no more data in the string port, it
returns an EOF.
```

## peek-u8
```
(peek-u8)
(peek-u8 port)

Return next byte from input-binary port. If there are no more bytes
it return eof object.
```

## pipe
```
(pipe . fns)

Higher-order function that creates a new function that applies all functions
from left to right and returns the last value. Reverse of compose.
e.g.:
((pipe (curry + 2) (curry * 3)) 10) ==> (* 3 (+ 2 10)) ==> 36
```

## plain-object?
```
(plain-object? x)

Checks if value is a plain JavaScript object created using the object macro.
```

## pluck
```
(pluck . strings)

If called with a single string it will return a function that when
called with an object will return that key from the object.
If called with more then one string the returned function will
create a new object by copying all properties from the given object.
```

## port?
```
(port? x)

Returns true if the argument is an input or output port object.
```

## positive?
```
(positive? x)

Checks if the number is larger then 0
```

## pprint
```
(pprint expression)

This function will pretty print its input to stdout. If it is called
with a non-list, it will just call the print function on its
input.
```

## pretty-format
```
(pretty-format pair)

Returns a pretty printed string from pair expression.
```

## print
```
(print . args)

This function converts each input into a string and prints
the result to the standard output (by default it's the
console but it can be defined in user code). This function
calls `(newline)` after printing each input.
```

## procedure?
```
(procedure? expression)

Predicate that tests if value is a callable function or continuation.
```

## promise
```
(promise . body)

Anaphoric macro that exposes resolve and reject functions from JS promise.
```

## promise?
```
(promise? obj)

Checks if the value is a promise created with delay or make-promise.
```

## promisify
```
(promisify fn)

Simple function for adding promises to NodeJS two-callback based functions.
Function tested only with fs module.
```

## prototype?
```
(prototype? obj)

Predicate that tests if value is a valid JavaScript prototype,
i.e. calling (new) with it will not throw '<x> is not a constructor'.
```

## pseudo-random-seed
```
(pseudo-random-seed)

Generate a new pseudo random seed for random.
```

## qsort
```
(qsort list predicate)

Sorts the list using the quick sort algorithm according to predicate.
```

## quasiquote
```
(quasiquote list)

Similar macro to `quote` but inside it you can use special expressions (unquote
x) abbreviated to ,x that will evaluate x and insert its value verbatim or
(unquote-splicing x) abbreviated to ,@x that will evaluate x and splice the value
into the result. Best used with macros but it can be used outside.
```

## quote
```
(quote expression) or 'expression

Macro that returns a single LIPS expression as data (it won't evaluate the
argument). It will return a list if put in front of LIPS code.
And if put in front of a symbol it will return the symbol itself, not the value
bound to that name.
```

## quote-promise
```
(quote-promise expr) or '>expr

Macro used to escape automatic awaiting of the expression. It will be wrapped
with a JavaScript class that behaves like Promise but will not be automatically
resolved by LIPS like normal promises are.
```

## quoted-symbol?
```
(quoted-symbol? code)

Helper function that tests if value is a quoted symbol. To be used in macros
that pass literal code that is transformed by parser.

usage:

  (define-macro (test x)
     (if (quoted-symbol? x)
         `',(cadr x)))

  (list 'hello (test 'world))
```

## quotient
```
(quotient a b)

Return quotient from division as integer.
```

## radians->degree
```
(radians->degree x)

Convert radians to degrees.
```

## raise
```
(raise obj)

Throws the object verbatim (no wrapping an a new Error).
```

## random
```
(random)
(random seed)

Function that generates new random real number using Knuth algorithm.
```

## range
```
(range stop)
(range start stop)
(range start stop step)

Returns a list of numbers from start to stop with optional step.
If start is not defined it starts from 0. If start is larger than stop
the step needs to be negative otherwise it will hang in an infinite loop.
```

## rational?
```
(rational? x)

Checks if the value is rational.
```

## rationalize
```
(rationalize number tolerance)

Returns simplest rational number approximation differing from number by no more
than the tolerance.
```

## read
```
(read [port])

This function, if called with a port, it will parse the next
item from the port. If called without an input, it will read
a string from standard input (using the browser's prompt or
a user defined input method) and parse it. This function can be
used together with `eval` to evaluate code from port.
```

## read-all
```
(read-all)
(read-all port)

Read all S-Expressions from port and return them as a list
```

## read-bytevector
```
(read-bytevector k)
(read-bytevector k port)

Read next n bytes from input-binary port. If there are no more bytes
it returns eof object. If there are less then n bytes in port it
return the only bytes that are available
```

## read-bytevector!
```
(read-bytevector! bytevector)
(read-bytevector! bytevector port)
(read-bytevector! bytevector port start)
(read-bytevector! bytevector port start end)

Reads next bytes from binary input port and write them into byte vector.
if not start is specified it start to write into 0 position of the vector until
the end or end the vector if no end is specified.
```

## read-char
```
(read-char port)

This function reads and returns the next character from the
input port.
```

## read-line
```
(read-line port)

This function reads and returns the next line from the input
port.
```

## read-string
```
(read-string k)
(read-string k port)

Reads the next k characters, or as many as are available
before the end of file, from the textual input port into a
newly allocated string in left-to-right order and returns the
string. If no characters are available before the end of file,
an end-of-file object is returned.
```

## read-u8
```
(read-u8)
(read-u8 port)

Read next byte from input-binary port. If there are no more bytes
it return eof object.
```

## real-part
```
(real-part n)

Return real part of the complex number n.
```

## real?
```
(real? x)

Checks if the argument x is real.
```

## reduce
```
(reduce fn init list . lists)

Higher-order function that takes each element of the list and calls
the fn with result of previous call or init and the next element
of the list until each element is processed, and returns a single value
as result of last call to `fn` function.
e.g. it computes (fn 'c 'z (fn 'b 'y (fn 'a 'x 'foo)))
for: (reduce fn 'foo '(a b c) '(x y z))
```

## regex
```
(regex re)
(regex re flags)

Creates a new regular expression from string, to not break Emacs formatting.
```

## regex?
```
(regex? x)

Returns true if value is a regular expression, or false otherwise.
```

## remainder
```
(% n1 n2)

Function returns the remainder of n1/n2 (modulo).
```

## remainder__
```
(modulo a b)

Returns remainder from division operation.
```

## replace
```
(replace pattern replacement string)

Function that changes pattern to replacement inside string. Pattern can be a
string or regex and replacement can be function or string. See Javascript
String.replace().
```

## repr
```
(repr obj)

Function that returns a LIPS code representation of the object as a string.
```

## require
```
(require module)

Function used inside Node.js to import a module.
```

## require.resolve
```
(require.resolve path)

Returns the path relative to the current module.

Only available when LIPS is running under Node.js.
```

## reset
```
(reset)

Function resets the environment and removes all user defined variables.
```

## response->content
```
(response->text binary res)

Reads all text from a Node.js HTTP response object. If binary argument
is true it will return Buffer object that can be converted to u8vector.

***Warning:*** it may overflow the Javascript call stack when converting the
whole buffer to u8vector, because LIPS doesn't have TCO.
```

## reverse
```
(reverse list)

Function that reverses the list or array. If value is not a list
or array it will error.
```

## round
```
(round number)

Function that calculates the round of a number.
```

## s16vector
```
(s16vector v1 v2 ...)

Create signed 16-bit integer vector (C short) from give arguments.
```

## s16vector-length
```
(s16vector-length v)

return length of signed 16-bit integer vector (C short).
```

## s16vector-ref
```
(s16vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## s16vector-set!
```
(s16vector-set! vector k)

Function set value of signed 16-bit integer vector (C short) at index k.
If index is out of range it throw exception.
```

## s16vector?
```
(s16vector? x)

Returns #t of argument is signed 16-bit integer vector (C short),
otherwise it return #f.
```

## s32vector
```
(s32vector v1 v2 ...)

Create signed 32-bit integer vector (C unsigned int) from give arguments.
```

## s32vector-length
```
(s32vector-length v)

return length of signed 32-bit integer vector (C unsigned int).
```

## s32vector-ref
```
(s32vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## s32vector-set!
```
(s32vector-set! vector k)

Function set value of signed 32-bit integer vector (C unsigned int) at index k.
If index is out of range it throw exception.
```

## s32vector?
```
(s32vector? x)

Returns #t of argument is signed 32-bit integer vector (C unsigned int),
otherwise it return #f.
```

## s8vector
```
(s8vector v1 v2 ...)

Create signed 8-bit integer vector (C signed char) from give arguments.
```

## s8vector-length
```
(s8vector-length v)

return length of signed 8-bit integer vector (C signed char).
```

## s8vector-ref
```
(s8vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## s8vector-set!
```
(s8vector-set! vector k)

Function set value of signed 8-bit integer vector (C signed char) at index k.
If index is out of range it throw exception.
```

## s8vector?
```
(s8vector? x)

Returns #t of argument is signed 8-bit integer vector (C signed char),
otherwise it return #f.
```

## scheme-report-environment
```
(scheme-report-environment version)

Returns new Environment object for given Scheme Spec version.
Only argument 5 is supported that create environment for R5RS.
```

## search
```
(search pattern string)

Function that returns the first found index of the pattern inside a string.
```

## set-car!
```
(set-car! obj value)

Function that sets the car (first item) of the list/pair to specified value.
The old value is lost.
```

## set-cdr!
```
(set-cdr! obj value)

Function that sets the cdr (tail) of the list/pair to specified value.
It will destroy the list. The old tail is lost.
```

## set-current-directory!
```
(set-current-directory! string)

Changes the current working directory to provided string.
```

## set-debug!
```
(set-debug!)
(set-debug! value)

Set debug internal value, used internally for debugging. You can use it
in LIPS with is-debug function.
```

## set-global!
```
(set-global! name)

Macro to make the name a Javascript global variable (i.e. accessible on globalThis).
```

## set-hash-syntax!
```
(set-hash-syntax! seq value)
(set-hash-syntax! seq #f)

Creates or removes hash syntax. The value can be a macro or a function.
The functions needs to return data that will be returned by the parser
when it finds the # + char or # + symbol in the input stream.
When the value equal to #f the syntax is removed.

e.g.:

(set-hash-syntax! #\+ (lambda (port)
                        `(quote ,(apply + (read port)))))

(print #+(1 2 3))
;; ==> 6
(print '#+(1 2 3))
;; ==> (quote 6)
```

## set-object!
```
(set-object! obj key value)
(set-object! obj key value props)

Function set a property of a JavaScript object. props should be a vector of pairs,
passed to Object.defineProperty.
```

## set-repr!
```
(add-repr! type fn)

Function that adds the string representation to the type, which should be
a constructor function.

Function fn should have args (obj q) and it should return a string. obj
is the value that need to be converted to a string. If the object is nested
and you need to use `repr` recursively, it should pass the second parameter q
to repr, so string will be quoted when it's true.

e.g.: (lambda (obj q) (string-append "<" (repr obj q) ">"))
```

## set-special!
```
(set-special! seq value [type])

Add a new syntax extension to the parser. When parser found the new seq string
in the input stream it will invoke the function or a macro and return the output
at parse time.

The arguments to the function or macro depends on the type of extension:

* lips.specials.SYMBOL will not process the next tokens only call the extension
* lips.specials.LITERAL will read next expression and pass it as first argument
* lips.specials.SPLICE will read next expression which needs to be a list and
spread the list into the function arguments.
```

## set!
```
(set! name value)

Macro that can be used to set the value of the variable or slot (mutate it).
set! searches the scope chain until it finds first non empty slot and sets it.
```

## shuffle
```
(shuffle obj)

Order items in vector or list in random order.
```

## sin
```
(sin n)

Function that calculates sine of a number.
```

## single
```
(single list)

Checks if argument is list with one element.
```

## some
```
(some fn . lists)

Higher-order function that calls fn on consecutive elements of the list of lists.
It stops and returns true when fn returns true. If none of the values give true,
some will return false. Analogous to Python any(map(fn, list)).
```

## sort
```
(sort list [predicate])

Sorts the list using optional predicate function. If no comparison function
is given it will use <= and sort in increasing order.
```

## split
```
(split separator string)

Function that creates a list by splitting string by separator which can
be a string or regular expression.
```

## sqrt
```
(sqrt number)

Function that returns the square root of the number.
```

## square
```
(square z)

Returns the square of z. This is equivalent to (* z z).
```

## string
```
(string chr1 chr2 ...)

Function that creates a new string from it's arguments. Each argument
needs to be a character object.
```

## string->list
```
(string->list string)

Returns a list of characters created from string.
```

## string->number
```
(string->number number [radix])

Function that parses a string into a number.
```

## string->symbol
```
(string->symbol string)

Function that converts a string to a LIPS symbol.
```

## string->utf8
```
(string->utf8 string)
(string->utf8 string start)
(string->utf8 string start end)

Converts string into u8 bytevector using utf8 encoding.
The start and end is the range of the input string for the conversion.
```

## string->vector
```
(string->list string)
(string->list string start)
(string->list string start end)

Function that copies given range of string to list. If no start is specified it use
start of the string, if no end is specified it convert to the end of the string.
```

## string-append
```
(concat . strings)

Function that creates a new string by joining its arguments.
```

## string-ci<?
```
(string-ci<? string1 string2 ...)

Returns true if strings are monotonically increasing, ignoring the case.
```

## string-ci<=?
```
(string-ci<=? string1 string2 ...)

Returns true if strings are monotonically non-decreasing, ignoring the case.
```

## string-ci=?
```
(string-ci=? string1 string2 ...)

Checks if all strings are equal, ignoring the case.
```

## string-ci>?
```
(string-ci>? string1 string2 ...)

Returns true if strings are monotonically decreasing, ignoring the case
```

## string-ci>=?
```
(string-ci>=? string1 string2 ...)

Returns true if strings are monotonically non-increasing, ignoring the case.
```

## string-copy
```
(string-copy x)

Creates a new string based on given argument.
```

## string-downcase
```
(string-downcase string)

Function convert a string passed as argument to lower case.
```

## string-fill!
```
(string-fill! symbol char)

Function that destructively fills the string with given character.
```

## string-foldcase
```
(string-foldcase string)

Returns lowercase string using the Unicode simple case-folding algorithm.
```

## string-for-each
```
(string-for-each fn string1 stringr2 ...)

Applies a function fn to each element of the strings, similar string-map.
But the return value is #void.
```

## string-join
```
(join separator list)

Function that returns a string by joining elements of the list using separator.
```

## string-length
```
(string-length string)

Returns the length of the string.
```

## string-map
```
(string-map fn string1 stringr2 ...)

Returns new string from applying function fn to each element
of the strings, similar to map for lists.
```

## string-ref
```
(string-ref string k)

Returns character inside string at given zero-based index.
```

## string-set!
```
(string-set! string index char)

Replaces character in string at a given index.
```

## string-split
```
(split separator string)

Function that creates a list by splitting string by separator which can
be a string or regular expression.
```

## string-upcase
```
(string-downcase string)

Function convert a string passed as argument to upper case.
```

## string?
```
(string? expression)

Predicate that tests if value is a string.
```

## string<?
```
(string<? string1 string2 ...)

Returns true if strings are monotonically increasing.
```

## string<=?
```
(string<? string1 string2 ...)

Returns true if strings are monotonically non-decreasing.
```

## string=?
```
(string=? string1 string2 ...)

Checks if all strings are equal.
```

## string>?
```
(string<? string1 string2 ...)

Returns true if strings are monotonically decreasing.
```

## string>=?
```
(string<? string1 string2 ...)

Returns true if strings are monotonically non-increasing.
```

## substring
```
(substring string start end)

Function that returns the slice of the string starting at start and ending
with end.
```

## sxml
```
(sxml expr)

Macro for JSX like syntax but with SXML.
e.g. usage:

(sxml (div (@ (data-foo "hello")
             (id "foo"))
          (span "hello")
          (span "world")))
;; ==> <div data-foo="hello" id="foo"><span>hello</span>
;; ==> <span>world</span></div>
```

## sxml-unquote
```
(sxml-unquote expression) or ~expression

Treat expression as code and evaluate it inside sxml, similar to unquote
with quasiquote.
```

## symbol->string
```
(symbol->string symbol)

Function that converts a LIPS symbol to a string.
```

## symbol-append
```
(symbol-append s1 s2 ...)

Function that creates a new symbol from symbols passed as arguments.
```

## symbol?
```
(symbol? expression)

Predicate that tests if value is a LIPS symbol.
```

## symbol=?
```
(symbol=? s1 s2 ...)

Checks if each value is symbol and it's the same according to string=? predicate.
```

## syntax-parameterize
```
(syntax-parameterize (bindings) body)

Macro work similar to let-syntax but the the bindnds will be exposed to the user.
With syntax-parameterize you can define anaphoric macros.
```

## syntax-rules
```
(syntax-rules () (pattern expression) ...)

Base of hygienic macros, it will return a new syntax expander
that works like Lisp macros.
```

## take
```
(take list n)

Returns n first values of the list.
```

## tan
```
(tan n)

Function that calculates tangent of a number.
```

## textual-port?
```
(textual-port? port)

Function that tests if argument is string port.
```

## throw
```
(throw string)

Throws a new exception.
```

## timer
```
(timer time . body)

Evaluates body after delay, it returns the timer ID from setTimeout.
To clear the timer you can use native JS clearTimeout function.
```

## tree->array
```
(tree->array list)

Function that converts a LIPS cons tree structure into a JavaScript array.
```

## tree-map
```
(tree-map fn tree)

Tree version of map. fn is invoked on every leaf.
```

## truncate
```
(truncate n)

Function that returns the integer part (floor) of a real number.
```

## try
```
(try expr (catch (e) code))
(try expr (catch (e) code) (finally code))
(try expr (finally code))

Macro that executes expr and catches any exceptions thrown. If catch is provided
it's executed when an error is thrown. If finally is provided it's always
executed at the end.
```

## type
```
(type object)

Function that returns the type of an object as string.
```

## typecheck
```
(typecheck label value type [position])

Checks the type of value and errors if the type is not one allowed.  Type can be
string or list of strings. The position optional argument is used to create a
proper error message for the nth argument of function calls.
```

## typecheck-args
```
(typecheck-args type label lst)

Function that makes sure that all items in list are of same type.
```

## typecheck-number
```
(typecheck-number label value type [position])

Function similar to typecheck but checks if the argument is a number
and specific type of number e.g. complex.
```

## typed-array?
```
(typed-array? o)

Function that tests if the arguments is a JavaScript typed array (Scheme byte vector).
```

## u16vector
```
(u16vector v1 v2 ...)

Create unsigned 16-bit integer vector (C unsigned short) from give arguments.
```

## u16vector-length
```
(u16vector-length v)

return length of unsigned 16-bit integer vector (C unsigned short).
```

## u16vector-ref
```
(u16vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## u16vector-set!
```
(u16vector-set! vector k)

Function set value of unsigned 16-bit integer vector (C unsigned short) at index k.
If index is out of range it throw exception.
```

## u16vector?
```
(u16vector? x)

Returns #t of argument is unsigned 16-bit integer vector (C unsigned short),
otherwise it return #f.
```

## u32vector
```
(u32vector v1 v2 ...)

Create unsigned 32-bit integer vector (C int) from give arguments.
```

## u32vector-length
```
(u32vector-length v)

return length of unsigned 32-bit integer vector (C int).
```

## u32vector-ref
```
(u32vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## u32vector-set!
```
(u32vector-set! vector k)

Function set value of unsigned 32-bit integer vector (C int) at index k.
If index is out of range it throw exception.
```

## u32vector?
```
(u32vector? x)

Returns #t of argument is unsigned 32-bit integer vector (C int),
otherwise it return #f.
```

## u8-ready?
```
(u8-ready?)
(u8-ready? port)

Returns #t if a byte is ready on the binary input port and returns #f otherwise.
If u8-ready? returns #t then the next read-u8 operation on the given port is
guaranteed not to hang. If the port is at end of file then u8-ready? returns #t.
```

## u8vector
```
(u8vector v1 v2 ...)

Create unsigned 8-bit integer vector (C unsigned char) from give arguments.
```

## u8vector-length
```
(u8vector-length v)

return length of unsigned 8-bit integer vector (C unsigned char).
```

## u8vector-ref
```
(u8vector-ref vector k)

Returns value from vector at index k.
If index is out of range it throw exception.
```

## u8vector-set!
```
(u8vector-set! vector k)

Function set value of unsigned 8-bit integer vector (C unsigned char) at index k.
If index is out of range it throw exception.
```

## u8vector?
```
(u8vector? x)

Returns #t of argument is unsigned 8-bit integer vector (C unsigned char),
otherwise it return #f.
```

## unary
```
(unary fn)

Returns a new function with arguments limited to one.
```

## unbind
```
(unbind fn)

Function that removes the weak 'this' binding from a function so you
can get properties from the actual function object.
```

## unfold
```
(unfold fn init)

Returns a list from the given function and init value. The function should
return a pair where first is the item added to the list and second is next value
passed to the function. If the function returns false it ends the loop.
```

## unquote
```
(unquote code) or ,code

Special form used in the quasiquote macro. It evaluates the expression inside and
substitutes the value into quasiquote's result.
```

## unquote-splicing
```
(unquote-splicing code) or ,@code

Special form used in the quasiquote macro. It evaluates the expression inside and
splices the list into quasiquote's result. If it is not the last element of the
expression, the computed value must be a pair.
```

## unset-repr!
```
(unset-repr! type)

Removes the string representation of the type, which should be constructor function,
added by add-repr! function.
```

## unset-special!
```
(unset-special! name)

Function that removes a special symbol from parser added by `set-special!`,
name must be a string.
```

## unset!
```
(unset! name)

Function to delete the specified name from environment.
Trying to access the name afterwards will error.
```

## utf8->string
```
(utf8->string u8vector)
(utf8->string u8vector start)
(utf8->string u8vector start end)

Converts u8 bytevector into string using utf8 encoding.
The start and end is the range of the input byte vector for the conversion.
```

## value
```
(value obj)

Function that unwraps LNumbers and converts '() to #void.
```

## values
```
(values a1 a2 ...)

If called with more then one element it will create a special
Values object that can be used in the call-with-values function.
```

## values-ref
```
(values-ref values n)

Returns n value of values object which is result of value function.
```

## vector
```
(vector 1 2 3 (+ 3 1)) or #(1 2 3 4)

Macro for defining vectors (Javascript Arrays). Vector literals are
automatically quoted, so you can't use expressions inside them, only other
literals, like other vectors or objects.
```

## vector->list
```
(vector->list vector)
(vector->list vector start)
(vector->list vector start end)

Function that copies given range of vector to list. If no start is specified it use
start of the vector, if no end is specified it convert to the end of the vector.
```

## vector->string
```
(vector->string vector)
(vector->string vector start)
(vector->string vector start end)

Returns new string created from vector of characters in given range.
If no start is given it create string from 0, if no end is given it return
string to the end.
```

## vector-append
```
(vector-append v1 v2 ...)

Returns new vector by combining it's arguments that should be vectors.
```

## vector-copy
```
(vector-copy vector)
(vector-copy vector start)
(vector-copy vector start end)

Returns a new vecotor that is a copy of given vector. If start
is not provided it starts at 0, if end it's not provided it copy
til the end of the given vector.
```

## vector-copy!
```
(vector-copy to at from)
(vector-copy to at from start)
(vector-copy to at from start end)

Copies the elements of vector from between start and end into
vector to starting at `at`. If start is missing it start at 0 and if end
is missing it copy til the end of the vector from. It throws an error
if vector from don't fit into the destination `to`.
```

## vector-fill!
```
(vector-fill! vector fill)
(vector-fill! vector fill start)
(vector-fill! vector fill start end)

Fill vector with a given value in given range. If start is not given is start
at 0. If end is not given it fill till the end if the vector.
```

## vector-for-each
```
(vector-for-each fn vector1 vector2 ...)

Invokes every Returns new vector from applying function fn to each element
of the vectors, similar to map for lists.
```

## vector-length
```
(vector-length vec)

Returns length of the vector. It errors if the argument is not a vector.
```

## vector-map
```
(vector-map fn vector1 vector2 ...)

Returns new vector from applying function fn to each element
of the vectors, similar to map for lists.
```

## vector-ref
```
(vector-ref vec n)

Returns nth element of the vector vec.
```

## vector-set!
```
(vector-set! vec n value)

Function that sets nth item of the vector to value.
```

## vector?
```
(vector? n)

Returns true if value is vector and false if not.
```

## wait
```
(wait time . expr)

Returns a promise that will resolve with the expression after delay.
```

## while
```
(while cond body)

Creates a loop, it executes cond and body until cond expression is false.
```

## with-exception-handler
```
(with-exception-handler handler thunk)

Procedure call and return value of thunk function, if exception happen
it call handler procedure.
```

## with-input-from-file
```
(with-input-from-file string thunk)

Procedure open file and make it current-input-port then thunk is executed.
After thunk is executed current-input-port is restored and file port
is closed.
```

## with-input-from-port
```
(with-input-from-port port thunk)

Procedure use port and make it current-input-port then thunk is executed.
After thunk is executed current-input-port is restored and given port
is closed.
```

## with-input-from-string
```
(with-input-from-string string thunk)

Procedure open string and make it current-input-port then thunk is executed.
After thunk is executed current-input-port is restored and string port
is closed.
```

## with-tags
```
(with-tags expression)

valutes LIPS shorter code for S-Expression equivalent of JSX.
e.g.:

(with-tags (:div (:class "item" :id "item-1")
                 (list (:span () "Random Item")
                       (:a (:onclick (lambda (e) (alert "close")))
                           "close"))))

Above expression can be passed to function that renders JSX (like render
in React, Preact) To get the string from the macro you can use vhtml
library from npm.
```

## write
```
(write obj [port])

Write object to standard output or give port. For strings it will include
wrap in quotes.
```

## write-bytevector
```
(write-bytevector bytevector)
(write-bytevector bytevector port)

Write byte vector into binary output port.
```

## write-char
```
(write-char string)
(write-char string port)

Writes the character char (not an external representation of the character)
to the given textual output port and returns an unspecified value.
```

## write-string
```
(write-string string)
(write-string string port)
(write-string string port start)
(write-string string port start end)

Writes the characters of string from start to end in left-toright order
to the textual output port.
```

## write-u8
```
(write-u8 byte)
(write-u8 byte port)

Write byte into binary output port.
```

## Y
```
(Y f)

  _ __   __    _            _       _      _ __   __         _   _  _
 /  \ \ / /   /  __        /   ____  \    /  \ \ / /    ____  \   \  \
+    \ v /   +   \ \      +   / ___|  +  +    \ v /    / ___|  +   +  +
|     \ /    |    \ \     |  | |__    |  |     \ /    | |__    |   |  |
|     | |    |    /  \    |  |  __|   |  |     | |    |  __|   |   |  |
|     | |    |   / /\ \   |  | |      |  |     | |    | |      |   |  |
+     |_|    +  /_/  \_\  +  |_|      +  +     |_|    |_|      +   +  +
 \_           \_           \_       _/    \_                 _/  _/ _/
```

## zero?
```
(zero? x)

Checks if the number is equal to 0
```

## zip
```
(zip list1 list2 ...)

Return list where elements are taken from each list.
e.g.:
(zip '(1 2 3) '(2 3 4))
;; ==> '((1 2) (2 3) (3 4))
```

