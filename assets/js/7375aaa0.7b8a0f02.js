"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[8664],{4374:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>o,contentTitle:()=>l,default:()=>g,frontMatter:()=>a,metadata:()=>i,toc:()=>c});var i=n(8189),r=n(4848),s=n(8453);const a={slug:"lexer",title:"Internals: State Machine Lexer",authors:"jcubic",image:"/img/lexer.png",tags:["lips","scheme","lexer","internals"]},l=void 0,o={authorsImageUrls:[void 0]},c=[];function u(e){const t={a:"a",p:"p",...(0,s.R)(),...e.components};return(0,r.jsxs)(t.p,{children:["The first version of LIPS Scheme had regex based tokenizer. It was using a single regex to split the\ninput string into tokens. In this article I will show the internals of the new\n",(0,r.jsx)(t.a,{href:"https://en.wikipedia.org/wiki/Lexical_analysis",children:"Lexer"})," in LIPS Scheme."]})}function g(e={}){const{wrapper:t}={...(0,s.R)(),...e.components};return t?(0,r.jsx)(t,{...e,children:(0,r.jsx)(u,{...e})}):u(e)}},8453:(e,t,n)=>{n.d(t,{R:()=>a,x:()=>l});var i=n(6540);const r={},s=i.createContext(r);function a(e){const t=i.useContext(s);return i.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function l(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:a(e.components),i.createElement(s.Provider,{value:t},e.children)}},8189:e=>{e.exports=JSON.parse('{"permalink":"/blog/lexer","editUrl":"https://github.com/jcubic/lips/tree/master/docs/blog/2025-02-20-lexer.md","source":"@site/blog/2025-02-20-lexer.md","title":"Internals: State Machine Lexer","description":"The first version of LIPS Scheme had regex based tokenizer. It was using a single regex to split the","date":"2025-02-20T00:00:00.000Z","tags":[{"inline":true,"label":"lips","permalink":"/blog/tags/lips"},{"inline":true,"label":"scheme","permalink":"/blog/tags/scheme"},{"inline":true,"label":"lexer","permalink":"/blog/tags/lexer"},{"inline":true,"label":"internals","permalink":"/blog/tags/internals"}],"readingTime":3.715,"hasTruncateMarker":true,"authors":[{"name":"Jakub T. Jankiewicz","title":"LIPS maintainer","url":"https://jakub.jankiewicz.org/","imageURL":"https://github.com/jcubic.png","key":"jcubic","page":null}],"frontMatter":{"slug":"lexer","title":"Internals: State Machine Lexer","authors":"jcubic","image":"/img/lexer.png","tags":["lips","scheme","lexer","internals"]},"unlisted":false,"nextItem":{"title":"Scheme Regex literals in Emacs","permalink":"/blog/emacs-scheme-regex"}}')}}]);