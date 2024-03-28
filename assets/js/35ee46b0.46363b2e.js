"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[2822],{6871:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>l,contentTitle:()=>o,default:()=>h,frontMatter:()=>r,metadata:()=>c,toc:()=>d});var i=s(5893),t=s(1151);const r={sidebar_position:7,description:"features of Node.js and Web REPL"},o="REPL",c={id:"lips/REPL",title:"REPL",description:"features of Node.js and Web REPL",source:"@site/docs/lips/REPL.md",sourceDirName:"lips",slug:"/lips/REPL",permalink:"/docs/lips/REPL",draft:!1,unlisted:!1,editUrl:"https://github.com/jcubic/lips-website/tree/docusaurus/docs/docs/lips/REPL.md",tags:[],version:"current",sidebarPosition:7,frontMatter:{sidebar_position:7,description:"features of Node.js and Web REPL"},sidebar:"tutorialSidebar",previous:{title:"Extending LIPS",permalink:"/docs/lips/extension"}},l={},d=[{value:"Web REPL",id:"web-repl",level:2},{value:"Node.js REPL",id:"nodejs-repl",level:2},{value:"Procedures useful in REPL",id:"procedures-useful-in-repl",level:2}];function a(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",ul:"ul",...(0,t.a)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(n.h1,{id:"repl",children:"REPL"}),"\n",(0,i.jsxs)(n.p,{children:["LIPS Scheme REPL (",(0,i.jsx)(n.a,{href:"https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop",children:"Read Even Print Loop"}),") is\na way to interact with running LIPS Scheme session."]}),"\n",(0,i.jsx)(n.h2,{id:"web-repl",children:"Web REPL"}),"\n",(0,i.jsxs)(n.p,{children:["Web REPL you can access from ",(0,i.jsx)(n.a,{href:"/",children:"Home page"})," or as a ",(0,i.jsx)(n.a,{href:"/#bookmark",children:"bookmarklet"})," use\n",(0,i.jsx)(n.a,{href:"https://terminal.jcubic.pl/",children:"jQuery Terminal"})," and supports those features:"]}),"\n",(0,i.jsxs)(n.ul,{children:["\n",(0,i.jsxs)(n.li,{children:["syntax highlighting using ",(0,i.jsx)(n.a,{href:"https://prismjs.com/",children:"Prism.js"}),","]}),"\n",(0,i.jsx)(n.li,{children:"parentheses matching - when you type close parenthesis it will jump for a split second into it's\nmatching open parenthesis,"}),"\n",(0,i.jsx)(n.li,{children:"auto indentation - when you press enter it auto indent and if you copy paste the code it will reformat it."}),"\n",(0,i.jsx)(n.li,{children:"doc string tooltip - when you hover over a symbol it will show the docstring in a tooltip"}),"\n"]}),"\n",(0,i.jsx)(n.h2,{id:"nodejs-repl",children:"Node.js REPL"}),"\n",(0,i.jsxs)(n.p,{children:["Node.js version of the REPL, also supports syntax highlighting and auto indentation. It also\nsupports ",(0,i.jsx)(n.a,{href:"https://github.com/nodejs/node/pull/47150",children:"paste bracket mode from Node.js"})," (added by\n",(0,i.jsx)(n.a,{href:"https://jcubic.pl/me",children:"Jakub T. Jankiewicz"})," and released in\n",(0,i.jsx)(n.a,{href:"https://nodejs.org/en/blog/release/v20.6.0",children:"v20.6.0"}),"), to properly handle copy-paste of Scheme\ncode."]}),"\n",(0,i.jsxs)(n.p,{children:["In the future, the Node.js REPL may also support parentheses matching. It's supported by\n",(0,i.jsx)(n.a,{href:"https://www.gnu.org/software/clisp/",children:"CLisp"})," and ",(0,i.jsx)(n.a,{href:"https://common-lisp.net/",children:"Common Lisp"}),"\ninterpreter."]}),"\n",(0,i.jsx)(n.h2,{id:"procedures-useful-in-repl",children:"Procedures useful in REPL"}),"\n",(0,i.jsx)(n.p,{children:"There are few procedures useful in the REPL:"}),"\n",(0,i.jsxs)(n.ul,{children:["\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"help"})," - prints doc string for a given procedure, macro, or a variable (see documentation about\n",(0,i.jsx)(n.a,{href:"/docs/lips/intro#doc-strings",children:"Doc Strings"}),"),"]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"apropos"})," - function return list of procedures from environment that match a string or a regex,"]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"env"})," - function returns list of symbols which is everything that is inside an environment,"]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"dir"})," - function return all properties from an object including those in prototype chain (a class)."]}),"\n",(0,i.jsxs)(n.li,{children:[(0,i.jsx)(n.code,{children:"repr"})," - function return representation of the object as a string, it's inspired by Python. The\n",(0,i.jsx)(n.code,{children:"repr"})," function accepts two arguments the second one is a boolean that indicate if it should work\nlike write or like display. Write will write string with quotes. So if you want the strings inside\nthe string to be quoted use ",(0,i.jsx)(n.code,{children:"(repr obj #t)"})]}),"\n"]}),"\n",(0,i.jsxs)(n.p,{children:["To read more about introspection of LIPS Scheme in REPL, see ",(0,i.jsx)(n.a,{href:"/docs/lips/reflection",children:"documentation about Reflection"}),"."]})]})}function h(e={}){const{wrapper:n}={...(0,t.a)(),...e.components};return n?(0,i.jsx)(n,{...e,children:(0,i.jsx)(a,{...e})}):a(e)}},1151:(e,n,s)=>{s.d(n,{Z:()=>c,a:()=>o});var i=s(7294);const t={},r=i.createContext(t);function o(e){const n=i.useContext(r);return i.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function c(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:o(e.components),i.createElement(r.Provider,{value:n},e.children)}}}]);