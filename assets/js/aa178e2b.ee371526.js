"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[7868],{3649:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>c,contentTitle:()=>r,default:()=>h,frontMatter:()=>a,metadata:()=>o,toc:()=>l});var i=s(5893),t=s(1151);const a={sidebar_position:6,description:"A way to extends LIPS syntax, not only with macros"},r="Extending LIPS",o={id:"lips/extension",title:"Extending LIPS",description:"A way to extends LIPS syntax, not only with macros",source:"@site/docs/lips/extension.md",sourceDirName:"lips",slug:"/lips/extension",permalink:"/docs/lips/extension",draft:!1,unlisted:!1,editUrl:"https://github.com/jcubic/lips-website/tree/docusaurus/docs/docs/lips/extension.md",tags:[],version:"current",sidebarPosition:6,frontMatter:{sidebar_position:6,description:"A way to extends LIPS syntax, not only with macros"},sidebar:"tutorialSidebar",previous:{title:"Functional and other utils",permalink:"/docs/lips/functional-helpers"},next:{title:"REPL",permalink:"/docs/lips/REPL"}},c={},l=[{value:"Macros",id:"macros",level:2},{value:"Hygienic macros",id:"hygienic-macros",level:3},{value:"Macroexpand",id:"macroexpand",level:3},{value:"Syntax extensions",id:"syntax-extensions",level:2},{value:"Splice syntax extensions",id:"splice-syntax-extensions",level:3},{value:"Symbol syntax extensions",id:"symbol-syntax-extensions",level:3},{value:"Autogensyms",id:"autogensyms",level:3},{value:"String interpolation",id:"string-interpolation",level:3},{value:"Accessing parser",id:"accessing-parser",level:3},{value:"Standard input",id:"standard-input",level:3},{value:"Limitations",id:"limitations",level:3},{value:"New Homoiconic data types",id:"new-homoiconic-data-types",level:2},{value:"Combining with syntax extensions",id:"combining-with-syntax-extensions",level:3}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",h3:"h3",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,t.a)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(n.h1,{id:"extending-lips",children:"Extending LIPS"}),"\n",(0,i.jsxs)(n.p,{children:["There are two ways to extend LIPS Scheme, one is through ",(0,i.jsx)(n.a,{href:"#macros",children:"macros"})," and the other ways is with\n",(0,i.jsx)(n.a,{href:"#syntax-extensions",children:"syntax extensions"}),"."]}),"\n",(0,i.jsx)(n.h2,{id:"macros",children:"Macros"}),"\n",(0,i.jsxs)(n.p,{children:["LIPS allow creating Lisp macros and Scheme hygienic macros. Right now the limitations of macros is\nthat they are runtime.  There are no expansion time. Macros act like function calls, but they\ntransform the code and the interpreter evaluates the code that is returned by the macro. They ware\nimplemented like this, because this is how I understood the macros when they first got\nimplemented. There is a ",(0,i.jsx)(n.a,{href:"https://github.com/jcubic/lips/issues/169",children:"plan to create proper macro\nexpansion"}),"."]}),"\n",(0,i.jsx)(n.p,{children:"Quasiquote works with object literals, like with vectors:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(let* ((x 10)\n       (y 20)\n       (obj `&(:x ,x :y ,y)))\n  (print obj))\n"})}),"\n",(0,i.jsxs)(n.p,{children:["to define a lisp macro, you use syntax defined in ",(0,i.jsx)(n.a,{href:"/docs/scheme-intro/macros",children:"Scheme Tutorial about Macros"}),"."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(define-macro (for var start end . body)\n  `(for-each (lambda (,var)\n               ,@body)\n             (range ,start ,(+ end 1))))\n\n(let ((result (vector)))\n  (for i 10 20\n       (result.push i))\n  (print result))\n;; ==> #(10 11 12 13 14 15 16 17 18 19 20)\n"})}),"\n",(0,i.jsx)(n.p,{children:"You can define macro that create shorthand syntax like in JavaScript:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-javascript",children:"const x = 10;\nconst y = 20;\nconst obj = { x, y };\nconsole.log(obj);\n// { x: 10, y: 20 }\n"})}),"\n",(0,i.jsx)(n.p,{children:"You can create macro that will work the same in LIPS Scheme:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(define (symbol->key symbol)\n  (string->symbol (string-append ":" (symbol->string symbol))))\n\n(define-macro (expand . args)\n  `(object ,@(reduce (lambda (symbol acc)\n                       (let ((key (symbol->key symbol)))\n                         (append acc (list key symbol))))\n                     \'()\n                     args)))\n(let* ((x 10)\n       (y 20)\n       (obj (expand x y)))\n  (print obj))\n;; ==> &(:x 10 :y 20)\n'})}),"\n",(0,i.jsx)(n.h3,{id:"hygienic-macros",children:"Hygienic macros"}),"\n",(0,i.jsxs)(n.p,{children:["LIPS define hygienic macros in form of standard ",(0,i.jsx)(n.code,{children:"syntax-rules"})," expression. Note that there are know\nbugs in ",(0,i.jsx)(n.code,{children:"syntax-rules"})," see ",(0,i.jsx)(n.a,{href:"https://github.com/jcubic/lips/issues/43",children:"issue #43 on GitHub"})," and ",(0,i.jsx)(n.a,{href:"https://github.com/jcubic/lips/blob/devel/tests/syntax.scm",children:"unit\ntests"})," that have tests marked as\nfailing."]}),"\n",(0,i.jsx)(n.p,{children:"If you find a case of failing macro, don't hessitate to create an issue. You can also check if your\ncase is not already listed on above links. You can also just create a comment on issue #43 with your\nbroken test case."}),"\n",(0,i.jsx)(n.p,{children:"LIPS Scheme define those extensions to syntax-rules macros:"}),"\n",(0,i.jsxs)(n.ul,{children:["\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.a,{href:"https://srfi.schemers.org/srfi-46/srfi-46.html",children:"SRFI-46"})," (changing ellipsis symbol: see\n",(0,i.jsx)(n.a,{href:"/docs/scheme-intro/macros#nested-hygienic-macros",children:"Nested Hygienic Macros"})]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.a,{href:"https://srfi.schemers.org/srfi-139/srfi-139.html",children:"SRFI-139"})," see\n",(0,i.jsx)(n.a,{href:"/docs/scheme-intro/macros#anaphoric-hygienic-macros",children:"Syntax Parameters"})]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.a,{href:"https://srfi.schemers.org/srfi-147/srfi-147.html",children:"SRFI 147"})," allow defining new syntax-rules transformers"]}),"\n"]}),"\n",(0,i.jsx)(n.h3,{id:"macroexpand",children:"Macroexpand"}),"\n",(0,i.jsxs)(n.p,{children:["LIPS define ",(0,i.jsx)(n.code,{children:"macroexpand"})," and ",(0,i.jsx)(n.code,{children:"macroexpand-1"})," but they are macros and the expression don't need to be quoted.\nThere is an ",(0,i.jsx)(n.a,{href:"https://github.com/jcubic/lips/issues/323",children:"issue to change those expressions into functions"})," like\nin ",(0,i.jsx)(n.a,{href:"http://clhs.lisp.se/Body/f_mexp_.htm",children:"Common Lisp"}),"."]}),"\n",(0,i.jsx)(n.h2,{id:"syntax-extensions",children:"Syntax extensions"}),"\n",(0,i.jsx)(n.p,{children:"Syntax extensions are a way to add new syntax to LIPS Scheme. They are executed at parse time. Object literals and\nvector literals are added using syntax extensions. Syntax extension modify the Parser and allow to add new behavior at\nparse time."}),"\n",(0,i.jsx)(n.p,{children:"To add syntax extension you use:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "##" \'my-function lips.specials.LITERAL)\n'})}),"\n",(0,i.jsx)(n.p,{children:"The syntax extension can point to a macro or a function. When extension is a function it's invoked and the result data\nis returned from the parser:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(define (my-function number)\n  `(list ,number ,number))\n"})}),"\n",(0,i.jsx)(n.p,{children:"if you define the function like this and execute:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"##10\n;; ==> (10 10)\n"})}),"\n",(0,i.jsxs)(n.p,{children:["To see the expansion of syntax extension you can use ",(0,i.jsx)(n.code,{children:"lips.parse"}),":"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(lips.parse "##10")\n;; ==> #((list 10 10))\n'})}),"\n",(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.strong,{children:"NOTE"}),": The ",(0,i.jsx)(n.code,{children:"lips.parse"})," function return array/vector of parsed expressions."]}),"\n",(0,i.jsxs)(n.p,{children:["There are 3 types of syntax extensions ",(0,i.jsx)(n.code,{children:"SPLICE"}),", ",(0,i.jsx)(n.code,{children:"LITERAL"}),", and ",(0,i.jsx)(n.code,{children:"SYMBOL"}),". You define them using\nconstants defined in ",(0,i.jsx)(n.code,{children:"lips.specials"})," object."]}),"\n",(0,i.jsxs)(n.ul,{children:["\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"LITERAL"})," - used above pass it's argument as is, with literal syntax extension you can execute it\non any argument. This is default when no constant in ",(0,i.jsx)(n.code,{children:"set-special!"})," is used."]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"SPLICE"})," - if you execute syntax ",(0,i.jsx)(n.code,{children:"##(1 2 3)"})," the arguments will be spliced, so the function or a\nmacro needs to use improper list. Or use named arguments if syntax accept fixed amount of arguments."]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"SYMBOL"})," - this type of extensions don't accept any arguments and can be used to define parser constants."]}),"\n"]}),"\n",(0,i.jsx)(n.h3,{id:"splice-syntax-extensions",children:"Splice syntax extensions"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "##" \'complex lips.specials.SPLICE)\n\n(define (complex real imag)\n  (make-rectangular real imag))\n'})}),"\n",(0,i.jsx)(n.p,{children:"This syntax extension will define complex numbers and will work only on lists:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"##(10 20)\n;; ==> 10+20i\n"})}),"\n",(0,i.jsx)(n.p,{children:"Since it's a macro it evaluate at parse time:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(lips.parse "##(10 20)")\n;; ==> #(10+20i)\n'})}),"\n",(0,i.jsxs)(n.p,{children:["With splice syntax extension you can limit the number of arguments (remember that LIPS don't check\n",(0,i.jsx)(n.a,{href:"https://en.wikipedia.org/wiki/Arity",children:"arity"}),")."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(define (complex . args)\n  (if (not (= (length args) 2))\n      (throw "Invalid invocation of ## syntax extension")\n    (apply make-rectangular args)))\n'})}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(lips.parse "##(10 20)")\n;; ==> #(10+20i)\n(lips.parse "##(1 2 3)")\n;; ==> Invalid invocation of ## syntax extension\n'})}),"\n",(0,i.jsx)(n.h3,{id:"symbol-syntax-extensions",children:"Symbol syntax extensions"}),"\n",(0,i.jsx)(n.p,{children:"The last type of syntax extensions are symbols they don't accept any arguments and can be used to\ndefine parser constants."}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(set-special! \"nil\" 'nil-fn lips.specials.SYMBOL)\n(define (nil-fn) '())\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This will define constant ",(0,i.jsx)(n.code,{children:"#nil"}),". It's different from ",(0,i.jsx)(n.code,{children:"nil"})," variable:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(define nil '())\n\n(eq? nil #nil)\n;; ==> #t\n(eq? (car '(nil)) (car '(#nil)))\n;; ==> #f\n(symbol? (car '(nil)))\n;; ==> #f\n(symbol? (car '(#nil)))\n;; ==> #f\n(eq? (car '(#nil)) '())\n;; ==> #t\n"})}),"\n",(0,i.jsx)(n.h3,{id:"autogensyms",children:"Autogensyms"}),"\n",(0,i.jsx)(n.p,{children:"With syntax extensions you can define autogensyms expressions:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(set-special! \"#:\" 'keyword lips.specials.LITERAL)\n\n(define (keyword symbol)\n  `(gensym ',symbol))\n\n(let ((x #:foo))\n  (write x))\n;; ==> #:foo\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This allow to create named ",(0,i.jsx)(n.a,{href:"/docs/lips/intro#gensyms",children:"gensyms"})," that are unique:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:"(eq? #:foo #:foo)\n;; ==> #f\n"})}),"\n",(0,i.jsxs)(n.p,{children:["You can use them with lisp macros instead of ",(0,i.jsx)(n.code,{children:"gensym"})," expressions. The autogensyms are actually part\nof the standard library."]}),"\n",(0,i.jsx)(n.h3,{id:"string-interpolation",children:"String interpolation"}),"\n",(0,i.jsx)(n.p,{children:"With syntax extensions you can create string interpolation that expand into a Scheme code:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "$" \'interpolate)\n\n(define (interpolate str)\n  (typecheck "interpolate" str "string")\n  (let* ((re #/(\\$\\{[^\\}]+\\})/)\n         (parts (--\x3e str (split re) (filter Boolean))))\n    `(string-append ,@(map (lambda (part)\n                             (if (not (null? (part.match re)))\n                                 (let* ((expr (part.replace #/(^\\$\\{)|(\\}$)/g ""))\n                                        (port (open-input-string expr))\n                                        (value (with-input-from-port port read)))\n                                   `(repr ,value))\n                                 part))\n                           (vector->list parts)))))\n\n(pprint (macroexpand-1 (let ((x 10)) $"x = ${(+ x 2)}")))\n;; ==> (let ((x 10))\n;; ==>   (string-append "x = " (repr (+ x 2))))\n\n(let ((x 10))\n  $"x = ${(+ x 2)}")\n;; ==> "x = 12"\n'})}),"\n",(0,i.jsxs)(n.p,{children:["The limitation of this solution is that you can't use strings inside ",(0,i.jsx)(n.code,{children:"${ ... }"}),". It will break the\nLexer.  In the future there may be a way to define such syntax extensions (See ",(0,i.jsx)(n.a,{href:"https://github.com/jcubic/lips/issues/321",children:"Add full string\ninterpolation as syntax extension"}),")."]}),"\n",(0,i.jsx)(n.h3,{id:"accessing-parser",children:"Accessing parser"}),"\n",(0,i.jsx)(n.p,{children:"In LIPS syntax extensions you can access the parser instance, so you can implement syntax\nextension that return line number:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "#:num" \'line-num lips.specials.SYMBOL)\n\n(define (line-num)\n  (let* ((lexer lips.__parser__.__lexer__)\n         (token lexer.__token__))\n    (write token)\n    (newline)\n    ;; line number start from 0\n    (+ token.line 1)))\n\n(print (list\n        #:num\n          #:num))\n;; ==> &(:token "#:num" :col 8 :offset 260 :line 11)\n;; ==> &(:token "#:num" :col 10 :offset 274 :line 12)\n;; ==> (12 13)\n'})}),"\n",(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.strong,{children:"NOTE"}),": The provided output will be exactly the same, when the code will be put into a single file\nand executed."]}),"\n",(0,i.jsx)(n.h3,{id:"standard-input",children:"Standard input"}),"\n",(0,i.jsxs)(n.p,{children:["In syntax extensions ",(0,i.jsx)(n.code,{children:"current-input-port"})," points into the parser stream. So you can implement\nyour own parser logic. The best way to implement custom syntax extension (that works similar to\ncommon lips reader macros)."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "$" \'raw-string lips.specials.SYMBOL)\n\n(define (raw-string)\n  (if (char=? (peek-char) #\\")\n      (begin\n        (read-char)\n        (let loop ((result (vector)) (char (peek-char)))\n          (read-char)\n          (if (char=? char #\\")\n              (apply string (vector->list result))\n              (loop (vector-append result (vector char)) (peek-char)))))))\n\n(print $"foo \\ bar")\n;; ==> "foo \\\\ bar"\n'})}),"\n",(0,i.jsxs)(n.p,{children:["This extension implements raw string, like in Python, where you don't need to escape the characters that are thread literally.\nSimilarly, you can implement strings that use backticks, you only need to replace ",(0,i.jsx)(n.code,{children:'#\\"'})," with ",(0,i.jsx)(n.code,{children:"#\\`"}),"."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! "$" \'raw-string lips.specials.SYMBOL)\n\n(define (raw-string)\n  (if (char=? (peek-char) #\\`)\n      (begin\n        (read-char)\n        (let loop ((result (vector)) (char (peek-char)))\n          (read-char)\n          (if (char=? char #\\`)\n              (apply string (vector->list result))\n              (loop (vector-append result (vector char)) (peek-char)))))))\n\n(print $`foo \\ bar`)\n;; ==> "foo \\\\ bar"\n'})}),"\n",(0,i.jsx)(n.p,{children:"With this feature in hand you can implement full string interpolation (that will probably be part of\nLIPS Scheme in the future)."}),"\n",(0,i.jsx)(n.h3,{id:"limitations",children:"Limitations"}),"\n",(0,i.jsx)(n.p,{children:"The limitation of syntax extensions is that you can't define a variable that starts with the\nsame characters as syntax extension. This may be a benefit and not a limitation:"}),"\n",(0,i.jsx)(n.h2,{id:"new-homoiconic-data-types",children:"New Homoiconic data types"}),"\n",(0,i.jsx)(n.p,{children:"With LIPS, you can define representation of custom data types that are the same when printed and read."}),"\n",(0,i.jsxs)(n.p,{children:["To create custom representation of new data type you can use ",(0,i.jsx)(n.code,{children:"set-repr!"})," expression. It only works\nwith JavaScript classes.  But Scheme records in LIPS define new JavaScript class. So you can create\nnew records and create different representation for them."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(define-record-type :Person\n  (make-person name age)\n  person?\n  (name person-name set-name!)\n  (age person-age set-age!))\n\n(set-repr! :Person (lambda (obj quot)\n                     (string-append "(make-person "\n                                    (repr (person-name obj) quot)\n                                    " "\n                                    (repr (person-age obj) quot)\n                                    ")")))\n\n(write (make-person "Mick Jagger" 80))\n;; ==> (make-person "Mick Jagger" 80)\n(display (make-person "Mick Jagger" 80))\n;; ==> (make-person Mick Jagger 80)\n'})}),"\n",(0,i.jsxs)(n.p,{children:["As you can see the ",(0,i.jsx)(n.code,{children:"display"})," don't quote the strings because of ",(0,i.jsx)(n.code,{children:"repr"})," expression that use ",(0,i.jsx)(n.code,{children:"quot"}),"\nargument to the ",(0,i.jsx)(n.code,{children:"set-repr!"})," handler."]}),"\n",(0,i.jsx)(n.h3,{id:"combining-with-syntax-extensions",children:"Combining with syntax extensions"}),"\n",(0,i.jsx)(n.p,{children:"You can combine syntax extensions with custom representation:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-scheme",children:'(set-special! ":P" \'make-person lips.specials.SPLICE)\n\n(set-repr! :Person (lambda (obj quot)\n                     (string-append ":P("\n                                    (repr (person-name obj) quot)\n                                    " "\n                                    (repr (person-age obj) quot)\n                                    ")")))\n\n(write :P("Mick Jagger" 80))\n;; ==> :P("Mick Jagger" 80)\n'})})]})}function h(e={}){const{wrapper:n}={...(0,t.a)(),...e.components};return n?(0,i.jsx)(n,{...e,children:(0,i.jsx)(d,{...e})}):d(e)}},1151:(e,n,s)=>{s.d(n,{Z:()=>o,a:()=>r});var i=s(7294);const t={},a=i.createContext(t);function r(e){const n=i.useContext(a);return i.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:r(e.components),i.createElement(a.Provider,{value:n},e.children)}}}]);