"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[2553],{3697:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>l,contentTitle:()=>r,default:()=>h,frontMatter:()=>c,metadata:()=>a,toc:()=>o});var t=s(5893),i=s(1151);const c={sidebar_position:3,description:"SXML it's what JSX is for JavaScript"},r="SXML (e.g. for React)",a={id:"lips/sxml",title:"SXML (e.g. for React)",description:"SXML it's what JSX is for JavaScript",source:"@site/docs/lips/sxml.md",sourceDirName:"lips",slug:"/lips/sxml",permalink:"/docs/lips/sxml",draft:!1,unlisted:!1,editUrl:"https://github.com/LIPS-scheme/lips/tree/master/docs/docs/lips/sxml.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3,description:"SXML it's what JSX is for JavaScript"},sidebar:"tutorialSidebar",previous:{title:"Reflection",permalink:"/docs/lips/reflection"},next:{title:"Environments",permalink:"/docs/lips/environments"}},l={},o=[{value:"Inserting the Scheme code into SXML",id:"inserting-the-scheme-code-into-sxml",level:2},{value:"Using SXML with React and Preact",id:"using-sxml-with-react-and-preact",level:2}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",ul:"ul",...(0,i.a)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"sxml-eg-for-react",children:"SXML (e.g. for React)"}),"\n",(0,t.jsxs)(n.p,{children:["SXML is a way to define XML or HTML inside Scheme code. In LIPS Scheme, it works like for JSX for libraries\nlike ",(0,t.jsx)(n.a,{href:"https://react.dev/",children:"React"})," or ",(0,t.jsx)(n.a,{href:"https://preactjs.com/",children:"Preact"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"By default, with JSX you define code like this:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-jsx",children:'function MessageButton({ message }) {\n    function clickHandler() {\n       alert(message);\n    }\n    return (\n        <button className="btn btn-primary" onClick={clickHandler}>\n          Click me!\n        </button>\n    );\n}\n'})}),"\n",(0,t.jsx)(n.p,{children:"The code defines a simple component that use a button and onClick handler."}),"\n",(0,t.jsx)(n.p,{children:"You can write the same code in LIPS as:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:'(define (MessageButton props)\n  (let ((click-handler (lambda ()\n                         (alert props.message))))\n    (sxml (button (@ (className "btn btn-primary")\n                     (onClick click-handler))\n                  "Click me!"))))\n'})}),"\n",(0,t.jsx)(n.p,{children:"To create an instance of this component, you use:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:'(MessageButton (@ (message "LIPS Scheme")))\n'})}),"\n",(0,t.jsxs)(n.p,{children:["The main element is ",(0,t.jsx)(n.code,{children:"sxml"})," macro that do the same transoformation as ",(0,t.jsx)(n.a,{href:"https://legacy.reactjs.org/docs/introducing-jsx.html",children:"JSX\ncompiler"})," like ",(0,t.jsx)(n.a,{href:"https://babeljs.io/",children:"Babel"})," do."]}),"\n",(0,t.jsx)(n.h2,{id:"inserting-the-scheme-code-into-sxml",children:"Inserting the Scheme code into SXML"}),"\n",(0,t.jsxs)(n.p,{children:["By default, symbols in SXML are treated as tags. If you want to put code like with ",(0,t.jsx)(n.code,{children:"{ }"})," in JSX, you\nneed to use ",(0,t.jsx)(n.code,{children:"~"})," symbol in front of S-Expression:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:"(let ((x 10))\n  (sxml (ul (li ~x)\n            (li ~(+ x 1))\n            (li ~(+ x 2)))))\n"})}),"\n",(0,t.jsx)(n.p,{children:"You can also array from escaped expression:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:"(sxml (ul ~(list->array\n            (map (lambda (x)\n                   (sxml (li ~x)))\n                 (range 10)))))\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Remember to use ",(0,t.jsx)(n.code,{children:"list->array"})," (or ",(0,t.jsx)(n.code,{children:"list->vector"}),") if you process lists."]}),"\n",(0,t.jsx)(n.h2,{id:"using-sxml-with-react-and-preact",children:"Using SXML with React and Preact"}),"\n",(0,t.jsxs)(n.p,{children:["To use SXML with React you need to specify the main function that is used to create tags in JSX.\nIn Preact is ",(0,t.jsx)(n.code,{children:"preact.h"})," and in React it's ",(0,t.jsx)(n.code,{children:"React.createElement"}),". Here is a required setup for them:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:"(define createElement React.createElement)\n(pragma->sxml createElement)\n(define <> React.Fragment)\n"})}),"\n",(0,t.jsx)(n.p,{children:"With Preact it will just this:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:"(define h preact.h)\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Because default ",(0,t.jsx)(n.code,{children:"pragma->sxml"})," is ",(0,t.jsx)(n.code,{children:"h"}),"."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:"(pragma->sxml h)\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Similarly, if you want to use SXML and ",(0,t.jsx)(n.code,{children:"sxml"})," macro in LIPS with other libraries that accept JSX, all\nyou have to do is run ",(0,t.jsx)(n.code,{children:"pragma->sxml"}),". This is macro that define ",(0,t.jsx)(n.code,{children:"sxml"})," macro with proper element\ncreation function."]}),"\n",(0,t.jsx)(n.p,{children:"Here are few example applications:"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsx)(n.li,{children:(0,t.jsx)(n.a,{href:"https://codepen.io/jcubic/pen/PojYxBP?editors=1000",children:"Preact"})}),"\n",(0,t.jsx)(n.li,{children:(0,t.jsx)(n.a,{href:"https://codepen.io/jcubic/pen/mdMBLwb?editors=1000",children:"React"})}),"\n"]})]})}function h(e={}){const{wrapper:n}={...(0,i.a)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(d,{...e})}):d(e)}},1151:(e,n,s)=>{s.d(n,{Z:()=>a,a:()=>r});var t=s(7294);const i={},c=t.createContext(i);function r(e){const n=t.useContext(c);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function a(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:r(e.components),t.createElement(c.Provider,{value:n},e.children)}}}]);