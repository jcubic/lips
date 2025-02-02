"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[2272],{5128:(e,i,n)=>{n.r(i),n.d(i,{assets:()=>h,contentTitle:()=>o,default:()=>d,frontMatter:()=>r,metadata:()=>s,toc:()=>c});const s=JSON.parse('{"id":"scheme-intro/what-is-lisp","title":"What is Lisp and Scheme?","description":"What is Lisp and what is Scheme and a bit of history","source":"@site/docs/scheme-intro/what-is-lisp.md","sourceDirName":"scheme-intro","slug":"/scheme-intro/what-is-lisp","permalink":"/docs/scheme-intro/what-is-lisp","draft":false,"unlisted":false,"editUrl":"https://github.com/jcubic/lips/tree/master/docs/docs/scheme-intro/what-is-lisp.md","tags":[],"version":"current","sidebarPosition":1,"frontMatter":{"sidebar_position":1,"description":"What is Lisp and what is Scheme and a bit of history"},"sidebar":"tutorialSidebar","previous":{"title":"Introduction to Scheme","permalink":"/docs/category/introduction-to-scheme"},"next":{"title":"Data Types","permalink":"/docs/scheme-intro/data-types"}}');var t=n(4848),a=n(8453);const r={sidebar_position:1,description:"What is Lisp and what is Scheme and a bit of history"},o="What is Lisp and Scheme?",h={},c=[{value:"S-Expressions",id:"s-expressions",level:2},{value:"Square brackets",id:"square-brackets",level:2},{value:"Nesting expressions",id:"nesting-expressions",level:2},{value:"What is Scheme",id:"what-is-scheme",level:2},{value:"REPL",id:"repl",level:2},{value:"Standards",id:"standards",level:3},{value:"Scheme Implementations",id:"scheme-implementations",level:3},{value:"SRFI Documents",id:"srfi-documents",level:3}];function l(e){const i={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",h3:"h3",header:"header",img:"img",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,a.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(i.header,{children:(0,t.jsx)(i.h1,{id:"what-is-lisp-and-scheme",children:"What is Lisp and Scheme?"})}),"\n",(0,t.jsx)(i.p,{children:(0,t.jsx)(i.a,{href:"https://xkcd.com/297/",children:(0,t.jsx)(i.img,{alt:"Lisp cycle",src:n(2091).A+"",width:"640",height:"211"})})}),"\n",(0,t.jsxs)(i.p,{children:["Lisp is the second-oldest programming language (after Fortran) that is still in use.  Lisp is an\nacronym for ",(0,t.jsx)(i.strong,{children:"LISt Processing"}),". It was invented by\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)",children:"John McCarthy"})," in 1958 at\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Massachusetts_Institute_of_Technology",children:"MIT"}),". The main feature of Lisp\nis its lack of syntax.  The idea for Lisp language came from mathematics, to be exact\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Lambda_calculus",children:"Lambda Calculus"})," defined by\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Alonzo_Church",children:"Alonzo Church"}),", which was invented or discovered to\nprove that the ",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Halting_problem",children:"halting problem"})," is unsolvable."]}),"\n",(0,t.jsxs)(i.p,{children:["The most distinguishing things about lisp is a notion that code and data are represented using the\nsame ",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Data_structure",children:"data structures"}),", in lisp they are lists. This\nis a very important characteristic, and it's called\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Homoiconicity",children:"Homoiconicity"}),"."]}),"\n",(0,t.jsx)(i.h2,{id:"s-expressions",children:"S-Expressions"}),"\n",(0,t.jsx)(i.p,{children:"In Lisp, everything is written as S-Expression, which is a list wrapped in parentheses with space\nbetween elements."}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{className:"language-scheme",children:"(+ 1 2 3)\n"})}),"\n",(0,t.jsx)(i.p,{children:"This is basic lisp expression. The difference between Scheme and other programming languages that often\nwrite the same expression as:"}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{className:"language-javascript",children:"1 + 2 + 3\n"})}),"\n",(0,t.jsx)(i.p,{children:"Is that in Lisp there are no operators. The above expression is just procedure application (function call)."}),"\n",(0,t.jsx)(i.admonition,{type:"info",children:(0,t.jsx)(i.p,{children:"We will use procedure and function interchangeably in this tutorial."})}),"\n",(0,t.jsx)(i.p,{children:"Plus is not an operator, only a symbol that point into an addition procedure that is executed. So in\nfact in other programming languages this should be written as:"}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{className:"language-javascript",children:"+(1, 2, 3)\n"})}),"\n",(0,t.jsx)(i.p,{children:"This is obviously invalid syntax (in most languages)."}),"\n",(0,t.jsx)(i.h2,{id:"square-brackets",children:"Square brackets"}),"\n",(0,t.jsx)(i.p,{children:"Some Scheme implementation supports brackets. They can be used interchangeably with parentheses.\nSome Lisps dialects require square brackets in specific places, example of such lisp is Clojure."}),"\n",(0,t.jsx)(i.p,{children:"This is example code that mix parentheses and brackets:"}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{className:"language-scheme",children:"(let ([x 10] [y 20])\n  (+ x y))\n"})}),"\n",(0,t.jsxs)(i.p,{children:["You can find more example of this in a book ",(0,t.jsx)(i.a,{href:"https://www.scheme.com/tspl4/",children:"The Scheme Programming\nLanguage"})]}),"\n",(0,t.jsx)(i.h2,{id:"nesting-expressions",children:"Nesting expressions"}),"\n",(0,t.jsx)(i.p,{children:"The S-Expressions can be nested:"}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{className:"language-scheme",children:"(+ (* 3 (/ 1 2)) (+ 1 2))\n"})}),"\n",(0,t.jsx)(i.p,{children:"But you can't add parentheses randomly to wrap expressions, like in other languages. Parentheses are\nalways procedure application (or special form that will be described later)."}),"\n",(0,t.jsx)(i.p,{children:"S-Expression is the most efficient way to write function application, and you can form with it any\nnested trees."}),"\n",(0,t.jsx)(i.h2,{id:"what-is-scheme",children:"What is Scheme"}),"\n",(0,t.jsx)(i.p,{children:"So now what is Scheme. Scheme is a dialect of Lisp, there are other well known dialects of Lisp,\nlike Common Lisp, Racket, Clojure. They all have one in common, they all use S-Expressions for\nsyntax (or lack of)."}),"\n",(0,t.jsxs)(i.p,{children:["Scheme was designed by ",(0,t.jsx)(i.em,{children:"Guy L. Steele"})," and ",(0,t.jsx)(i.em,{children:"Gerald Jay Sussman"})," in a 1970s. They were playing with\nan idea called the actor model and trying to understand it by creating a simple implementation. That\nimplementation later led to Scheme programming language."]}),"\n",(0,t.jsx)(i.h2,{id:"repl",children:"REPL"}),"\n",(0,t.jsxs)(i.p,{children:["REPL or ",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop",children:"Read-Eval-Print Loop"}),",\nis a way to interact with interpreter in an interactive way. Most modern interpreted programming languages\nhave some kind of REPL, but it was first introduced in 1964 by\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/L._Peter_Deutsch",children:"L. Peter Deutsch"})," and\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Edmund_Berkeley",children:"Edmund Berkele"})," for Lisp implementation on\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/PDP-1",children:"PDP-1"}),"."]}),"\n",(0,t.jsxs)(i.p,{children:["To run REPL you often need to run scheme or lisp executable. It's often called from\nthe ",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Terminal_emulator",children:"terminal interface"}),".\nWhen the scheme or lisp system runs you will get a\n",(0,t.jsx)(i.a,{href:"https://en.wikipedia.org/wiki/Command-line_interface#Command_prompt",children:"prompt"})," that may look like this:"]}),"\n",(0,t.jsx)(i.pre,{children:(0,t.jsx)(i.code,{children:"scheme>\n"})}),"\n",(0,t.jsx)(i.p,{children:"And you can type your scheme code and press enter to execute it (it's often called evaluation of the expression)."}),"\n",(0,t.jsx)(i.admonition,{type:"info",children:(0,t.jsxs)(i.p,{children:["You can run ",(0,t.jsx)(i.a,{href:"/#bookmark",children:"LIPS bookmarklet"})," while reading this tutorial. But note that it\ndoesn't yet support ",(0,t.jsx)(i.a,{href:"/docs/scheme-intro/continuations",children:"continuations"})," and TCO (",(0,t.jsx)(i.a,{href:"/docs/scheme-intro/core#tail-call-optimization",children:"Tail Call\nOptimization"}),"."]})}),"\n",(0,t.jsx)(i.h3,{id:"standards",children:"Standards"}),"\n",(0,t.jsxs)(i.p,{children:["Scheme is standardized in form of ",(0,t.jsxs)(i.a,{href:"https://standards.scheme.org/",children:["R",(0,t.jsx)("sup",{children:"n"}),"RS documents"]}),".\nRevised",(0,t.jsx)("sup",{children:"n"})," Report on the Algorithmic Language Scheme. Where power indicate how many times\nit was revisited. Power of 2 means Revisited Revisited."]}),"\n",(0,t.jsxs)(i.p,{children:["The latest standard is R",(0,t.jsx)("sup",{children:"7"}),"RS Small, and there is version large in the making."]}),"\n",(0,t.jsx)(i.h3,{id:"scheme-implementations",children:"Scheme Implementations"}),"\n",(0,t.jsxs)(i.p,{children:["You can find different implementations of the Scheme programming language that are more or less\ncompatible with R",(0,t.jsx)("sup",{children:"n"}),"RS specifications."]}),"\n",(0,t.jsx)(i.p,{children:"Example implementations:"}),"\n",(0,t.jsxs)(i.ul,{children:["\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://www.gnu.org/software/guile/",children:"Guile"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://www.gnu.org/software/kawa/index.html",children:"Kawa"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://gambitscheme.org/",children:"Gambit"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://practical-scheme.net/gauche/",children:"Gauche"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://www.call-cc.org/",children:"Chiken"})}),"\n",(0,t.jsx)(i.li,{children:(0,t.jsx)(i.a,{href:"https://lips.js.org/",children:"LIPS"})}),"\n"]}),"\n",(0,t.jsxs)(i.p,{children:["The official website for Scheme programming language is ",(0,t.jsx)(i.a,{href:"https://www.scheme.org/",children:"scheme.org"}),", which\ncontains more up to date ",(0,t.jsx)(i.a,{href:"https://get.scheme.org/",children:"list of Scheme implementations"})," and\n",(0,t.jsx)(i.a,{href:"https://docs.scheme.org/surveys/",children:"Surveys"})," that compares different quirks between implementations."]}),"\n",(0,t.jsx)(i.h3,{id:"srfi-documents",children:"SRFI Documents"}),"\n",(0,t.jsxs)(i.p,{children:["SRFI stands for Scheme Requests for Implementations. And are official documents that add new\nfeatures to the languages. Some of the SRFI may land in new version of R",(0,t.jsx)("sup",{children:"n"}),"RS specification\n(and some of them are part of latest R",(0,t.jsx)("sup",{children:"7"}),"RS spec). The website for SRFI documents is\nlocated at ",(0,t.jsx)(i.a,{href:"https://srfi.schemers.org/",children:"srfi.schemers.org"}),"."]})]})}function d(e={}){const{wrapper:i}={...(0,a.R)(),...e.components};return i?(0,t.jsx)(i,{...e,children:(0,t.jsx)(l,{...e})}):l(e)}},2091:(e,i,n)=>{n.d(i,{A:()=>s});const s=n.p+"assets/images/lisp_cycles-ca105433db10b3c9c4ad7a4454c84fa0.png"},8453:(e,i,n)=>{n.d(i,{R:()=>r,x:()=>o});var s=n(6540);const t={},a=s.createContext(t);function r(e){const i=s.useContext(a);return s.useMemo((function(){return"function"==typeof e?e(i):{...i,...e}}),[i,e])}function o(e){let i;return i=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:r(e.components),s.createElement(a.Provider,{value:i},e.children)}}}]);