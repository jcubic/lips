"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[6296],{3528:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>c,contentTitle:()=>i,default:()=>h,frontMatter:()=>t,metadata:()=>l,toc:()=>o});var r=s(5893),a=s(1151);const t={sidebar_position:5,description:"Code that allows to do more with less"},i="Functional and other utils",l={id:"lips/functional-helpers",title:"Functional and other utils",description:"Code that allows to do more with less",source:"@site/docs/lips/functional-helpers.md",sourceDirName:"lips",slug:"/lips/functional-helpers",permalink:"/docs/lips/functional-helpers",draft:!1,unlisted:!1,editUrl:"https://github.com/LIPS-scheme/lips/tree/master/docs/docs/lips/functional-helpers.md",tags:[],version:"current",sidebarPosition:5,frontMatter:{sidebar_position:5,description:"Code that allows to do more with less"},sidebar:"tutorialSidebar",previous:{title:"Environments",permalink:"/docs/lips/environments"},next:{title:"Extending LIPS",permalink:"/docs/lips/extension"}},c={},o=[{value:"Curry",id:"curry",level:2},{value:"Take and drop",id:"take-and-drop",level:2},{value:"range",id:"range",level:2},{value:"filter",id:"filter",level:2},{value:"complement",id:"complement",level:2},{value:"pluck",id:"pluck",level:2},{value:"flip",id:"flip",level:2},{value:"Combinations of functions",id:"combinations-of-functions",level:2},{value:"Unary, binary, and n-ary",id:"unary-binary-and-n-ary",level:2},{value:"always and once",id:"always-and-once",level:2},{value:"some and every",id:"some-and-every",level:2},{value:"pipe",id:"pipe",level:2},{value:"folding",id:"folding",level:2},{value:"unfold",id:"unfold",level:2},{value:"flatten",id:"flatten",level:2}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,a.a)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(n.h1,{id:"functional-and-other-utils",children:"Functional and other utils"}),"\n",(0,r.jsxs)(n.p,{children:["LIPS Scheme provide various of utility functions. Some of them are inspired by ",(0,r.jsx)(n.a,{href:"https://ramdajs.com/",children:"Ramda.js\nlibrary"})," and ",(0,r.jsx)(n.a,{href:"https://lodash.com/",children:"Lodash"}),". Some of those functions are\ndefined in ",(0,r.jsx)(n.a,{href:"https://srfi.schemers.org/srfi-1/srfi-1.html",children:"SRFI-1"}),"."]}),"\n",(0,r.jsx)(n.h2,{id:"curry",children:"Curry"}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.a,{href:"https://en.wikipedia.org/wiki/Currying",children:"Curry"})," is a common function in functional programming that\nreturn a new function with predefined arguments. The classic version, returns functions that accept\none argument and keep returning new function until all argumments are passed. In LIPS there is more\nuseful version of curry, that allow to pass more than one argument at the time. This is a common way\ncurry is implemented. This is working in LIPS because Scheme lambdas has length property that\nindicate number of arguments."]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define (sum a b c)\n  (+ a b c))\n\n(define add1 (curry sum 1))\n\n(print (add1 2 4))\n;; ==> #<procedure>\n"})}),"\n",(0,r.jsx)(n.h2,{id:"take-and-drop",children:"Take and drop"}),"\n",(0,r.jsx)(n.p,{children:"Take and drop procedures operates on lists and return a new list with:"}),"\n",(0,r.jsxs)(n.ul,{children:["\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.code,{children:"take"})," - only first n elements"]}),"\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.code,{children:"drop"})," - first elements removed"]}),"\n"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define lst '(1 2 3 4 5))\n\n(take lst 3)\n;; ==> (1 2 3)\n(drop lst 3)\n;; ==> (4 5)\n(equal? lst (append! (take lst 3) (drop lst 3)))\n;; ==> #t\n"})}),"\n",(0,r.jsx)(n.h2,{id:"range",children:"range"}),"\n",(0,r.jsx)(n.p,{children:"This is common function from Python. LIPS Scheme version works exactly the same and return list of numbers:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(range 10)\n;; ==> (0 1 2 3 4 5 6 7 8 9)\n(range 5 10)\n;; ==> (5 6 7 8 9)\n(range 0 10 2)\n;; ==> (0 2 4 6 8)\n(range 0 -10 -2)\n;; ==> (0 -2 -4 -6 -8 -10)\n"})}),"\n",(0,r.jsxs)(n.p,{children:["If used with one argument it returns ",(0,r.jsx)(n.code,{children:"n"})," numbers starting from ",(0,r.jsx)(n.code,{children:"0"}),".\nIf used with two arguments, the first one is starting number and the second one is the limit.\nWhen used with tree arguments, the last arguments is a step between the result numbers."]}),"\n",(0,r.jsx)(n.h2,{id:"filter",children:"filter"}),"\n",(0,r.jsx)(n.p,{children:"This is a common function in JavaScript and Python. But LIPS procedure also allow accepting\nregular expression as a filter."}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(filter odd? (range 10))\n;; ==> (1 3 5 7 9)\n(filter #/0|7/ (range 10))\n;; ==> (0 7)\n"})}),"\n",(0,r.jsx)(n.h2,{id:"complement",children:"complement"}),"\n",(0,r.jsx)(n.p,{children:"Function return the opposite of the predicate:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define not-null? (complement null?))\n(not-null? #null)\n;; ==> #f\n(not-null? 10)\n;; ==> #t\n"})}),"\n",(0,r.jsx)(n.h2,{id:"pluck",children:"pluck"}),"\n",(0,r.jsx)(n.p,{children:"This is a procedure that operate on JavaScript objects it return procedure that return specified fields from an object.\nIf you pass single argumnent the function will return the value. Of you pass more than one argument it will return\nan object with only those keys provided as arguments. Arguments can be strings or symbols."}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(define jack &(:first "Jack" :last "Kirby" :age 77))\n(define stan &(:first "Stan" :last "Lee" :age 96))\n(define steve &(:first "Steve" :last "Ditko" :age 91))\n\n(define get-name (pluck "first"))\n(string-append (get-name stan)\n               " likes "\n               (get-name jack)\n               " and "\n               (get-name steve))\n;; ==> "Stan likes Jack and Steve"\n\n(define full-name-data (pluck "first" "last"))\n\n\n(map full-name-data (list jack stan))\n;; ==> (&(:first "Jack" :last "Kirby") &(:first "Stan" :last "Lee"))\n\n(define (full-name person)\n  (let ((person (full-name-data person)))\n    (--\x3e (Object.values person) (join " "))))\n\n(map full-name (list jack stan steve))\n;; ==> ("Jack Kirby" "Stan Lee" "Steve Ditko")\n'})}),"\n",(0,r.jsxs)(n.p,{children:["The last example use interop with JavaScript see ",(0,r.jsx)(n.a,{href:"/docs/lips/intro#integration-with-javascript",children:"Integration with\nJavaScript"})," to know more."]}),"\n",(0,r.jsx)(n.h2,{id:"flip",children:"flip"}),"\n",(0,r.jsx)(n.p,{children:"This is very useful procedure that return new procedure with swapped first two arguments."}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(take '(1 2 3 4) 2)\n;; ==> (1 2)\n(define take (flip take))\n(take 2 '(1 2 3 4))\n;; ==> (1 2)\n(unset! take)\n"})}),"\n",(0,r.jsxs)(n.p,{children:["This function helps in composing functions with functions like ",(0,r.jsx)(n.code,{children:"curry"}),". ",(0,r.jsx)(n.code,{children:"unset!"})," is a function that\nremoves the binding of the first appearance of the object. Here we define take inside the current\nenvironment and you can ",(0,r.jsx)(n.code,{children:"unset!"})," it, to get the original value back."]}),"\n",(0,r.jsx)(n.h2,{id:"combinations-of-functions",children:"Combinations of functions"}),"\n",(0,r.jsx)(n.p,{children:"You can use curry with filter to create filter procedures:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define non-zero (curry filter (complement zero?)))\n\n(non-zero '(1 0 2 3 0 4 5 0 6 7 0 8 9))\n;; ==> (1 2 3 4 5 6 7 8 9)\n"})}),"\n",(0,r.jsx)(n.p,{children:"Another thing you can do is curry the take procedure to get only two elements from the list with help of flip:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define first-two (curry (flip take) 2))\n(first-two '(1 2 3 4))\n;; ==> (1 2)\n"})}),"\n",(0,r.jsx)(n.h2,{id:"unary-binary-and-n-ary",children:"Unary, binary, and n-ary"}),"\n",(0,r.jsx)(n.p,{children:"With LIPS you can change the arity of the function by forcing only specific number of arguments."}),"\n",(0,r.jsx)(n.p,{children:"This is a classic error:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(--\x3e #("1" "2" "3" "4") (map string->number))\n;; ==> #(1 +nan.0 +nan.0 +nan.0)\n'})}),"\n",(0,r.jsxs)(n.p,{children:["The error happen because Array::map pass additional arguments not only a value, and second argument\nto ",(0,r.jsx)(n.code,{children:"string->number"})," is Radix of the number (number base, default ",(0,r.jsx)(n.code,{children:"10"}),"). To fix the issue you can use ",(0,r.jsx)(n.code,{children:"unary"}),":"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(--\x3e #("1" "2" "3" "4") (map (unary string->number)))\n;; ==> #(1 2 3 4)\n'})}),"\n",(0,r.jsx)(n.p,{children:"Binary and n-ary work similarly but limit the number of arguments to 2 or any number."}),"\n",(0,r.jsx)(n.h2,{id:"always-and-once",children:"always and once"}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.code,{children:"always"})," is a procedure that return procedure that always return same value"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(map (always 1) (range 10))\n;; ==> (1 1 1 1 1 1 1 1 1 1)\n"})}),"\n",(0,r.jsxs)(n.p,{children:["And ",(0,r.jsx)(n.code,{children:"once"})," is a procedure that execute target procedure only once."]}),"\n",(0,r.jsx)(n.p,{children:"Let's create a macro that will count how many times the code is executed:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define-macro (with-time label expr)\n  (let ((result #:result))\n    `(begin\n       (console.time ,label)\n       (try\n        ,expr\n        (finally\n         (console.timeEnd ,label))))))\n"})}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.strong,{children:"NOTE"})," ",(0,r.jsx)(n.code,{children:"#:result"})," expression is ",(0,r.jsx)(n.a,{href:"/docs/lips/extension#autogensyms",children:"auto gensym"})," as one of\nbuiltin ",(0,r.jsx)(n.a,{href:"/docs/lips/extension#syntax-extensions",children:"syntax extensions"}),"."]}),"\n",(0,r.jsx)(n.p,{children:"We can use this code to make sure that the function has been executed only once:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(define (expensive value)\n  (new Promise (lambda (resolve)\n                 (setTimeout (curry resolve value) 1000))))\n\n(with-time "expensive" (expensive "hello"))\n;; ==> expensive: 1.003s\n;; ==> "hello"\n(define only-once (once expensive))\n\n(with-time "expensive" (only-once "message"))\n;; ==> expensive: 1.023s\n;; ==> "message"\n\n(with-time "expensive" (only-once "message"))\n;; ==> expensive: 9.609ms\n;; ==> "message"\n\n(with-time "expensive" (only-once "different message"))\n;; ==> expensive: 10.022ms\n;; ==> "message"\n'})}),"\n",(0,r.jsx)(n.h2,{id:"some-and-every",children:"some and every"}),"\n",(0,r.jsxs)(n.p,{children:["Work like JavaScript\n",(0,r.jsx)(n.a,{href:"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some",children:"Array::some"}),"\nand\n",(0,r.jsx)(n.a,{href:"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every",children:"Array::every"}),".\nBut the operate on lists and return true when predicate return true of any element (",(0,r.jsx)(n.code,{children:"some"}),") or for\nall elemebts (",(0,r.jsx)(n.code,{children:"every"}),")."]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(some null? '(1 2 3 #null))\n;; ==> #t\n(some null? '(1 2 3))\n;; ==> #f\n"})}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(every number? '(1 2 3 4))\n;; ==> #t\n(every number? '(1 2 3 \"4\"))\n;; ==> #f\n"})}),"\n",(0,r.jsx)(n.h2,{id:"pipe",children:"pipe"}),"\n",(0,r.jsx)(n.p,{children:"Pipe is higher ordder procedure that accept functions as arguments and return a new function that apply those function in order:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define non-zero (curry filter (complement zero?)))\n(define (fraction x)\n  (/ 1 x))\n\n(define calculate (pipe non-zero (curry map fraction)))\n\n(calculate '(1 2 0 3 4 0 5 6 0 7 8 0 9))\n;; ==> (1 1/2 1/3 1/4 1/5 1/6 1/7 1/8 1/9)\n"})}),"\n",(0,r.jsx)(n.p,{children:"The code removes the zeros from list before applying the fraction that will throw an error on zero."}),"\n",(0,r.jsx)(n.h2,{id:"folding",children:"folding"}),"\n",(0,r.jsxs)(n.p,{children:["LIPS define function ",(0,r.jsx)(n.code,{children:"reduce"})," that is an alias to standard Scheme procedure ",(0,r.jsx)(n.code,{children:"fold-right"})," and fold that is the same\nas ",(0,r.jsx)(n.code,{children:"fold-left"}),". Both procedures works similarly. The take a procedure and a list and reduce it into a single value."]}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.strong,{children:"NOTE"})," the reduce works differently than in JavaScript, the callback function get accumulator in last argument."]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(reduce cons '() '(1 2 3 4 5))\n;; ==> (5 4 3 2 1)\n"})}),"\n",(0,r.jsx)(n.p,{children:"The function also accept more than one list."}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(reduce (lambda (num str acc)\n          (cons num (cons str acc)))\n        \'()\n        \'(1 2 3 4 5)\n        \'("foo" "bar" "baz" "quuz"))\n;; ==> (4 "quuz" 3 "baz" 2 "bar" 1 "foo")\n'})}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.code,{children:"fold"})," function work similarly but the order of execution is reversed."]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(fold cons '() '(1 2 3 4))\n;; ==> (1 2 3 4)\n"})}),"\n",(0,r.jsx)(n.p,{children:"Same as reduce it accept more than one list:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:'(fold (lambda (num str acc)\n          (cons num (cons str acc)))\n        \'()\n        \'(1 2 3 4 5)\n        \'("foo" "bar" "baz" "quuz"))\n;; ==> (1 "foo" 2 "bar" 3 "baz" 4 "quuz")\n'})}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.strong,{children:"NOTE"}),": here we use ",(0,r.jsx)(n.code,{children:"cons"})," to create a list, ",(0,r.jsx)(n.code,{children:"cons"})," construct the list in reverse order so ",(0,r.jsx)(n.code,{children:"reduce"}),"\nstart from first element and ",(0,r.jsx)(n.code,{children:"fold"})," is reversed:"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(reduce (lambda (item acc)\n          (print acc)\n          (cons item acc))\n        '()\n        '(1 2 3 4))\n;; ==> (1)\n;; ==> (2 1)\n;; ==> (3 2 1)\n;; ==> (4 3 2 1)\n"})}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(fold (lambda (item acc)\n          (print acc)\n          (cons item acc))\n        '()\n        '(1 2 3 4))\n;; ==> (4)\n;; ==> (3 4)\n;; ==> (2 3 4)\n;; ==> (1 2 3 4)\n"})}),"\n",(0,r.jsx)(n.h2,{id:"unfold",children:"unfold"}),"\n",(0,r.jsxs)(n.p,{children:["Unfold is the opposite of folding. You can use it to create a list based on single function.\nThe ",(0,r.jsx)(n.a,{href:"https://en.wikipedia.org/wiki/Callback_(computer_programming)",children:"callback function"})," accept next item and should return\n#f when done or pair of two values element that should be added to the output list and next value."]}),"\n",(0,r.jsx)(n.p,{children:"Here is example of a procedure that use:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(unfold (lambda (n)\n          (if (> n 50)\n              false\n              (cons n (+ n 10))))\n        10)\n;; ==> (10 20 30 40 50)\n"})}),"\n",(0,r.jsx)(n.p,{children:"And here is more complex example with a utility function:"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(define (range-between a b)\n  (let* ((inc (< a b))\n         (test (if inc > <))\n         (op (if inc + -)))\n    (unfold (lambda (x)\n                  (if (test x b)\n                      false\n                      (cons x (op x 1))))\n            a)))\n\n(range-between 10 20)\n;; ==> (10 11 12 13 14 15 16 17 18 19 20)\n"})}),"\n",(0,r.jsx)(n.h2,{id:"flatten",children:"flatten"}),"\n",(0,r.jsxs)(n.p,{children:["This procedure flattens the tree structure into flat list, similar to\n",(0,r.jsxs)(n.a,{href:"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flat",children:[(0,r.jsx)(n.code,{children:"Array::flat"})," in JavaScript"]}),"."]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-scheme",children:"(flatten '(((((1) 2) 3) 4) 5))\n;; ==> (1 2 3 4 5)\n"})})]})}function h(e={}){const{wrapper:n}={...(0,a.a)(),...e.components};return n?(0,r.jsx)(n,{...e,children:(0,r.jsx)(d,{...e})}):d(e)}},1151:(e,n,s)=>{s.d(n,{Z:()=>l,a:()=>i});var r=s(7294);const a={},t=r.createContext(a);function i(e){const n=r.useContext(t);return r.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function l(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(a):e.components||a:i(e.components),r.createElement(t.Provider,{value:n},e.children)}}}]);