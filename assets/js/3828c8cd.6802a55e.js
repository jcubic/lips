"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[1208],{6388:(e,t,s)=>{s.r(t),s.d(t,{assets:()=>c,contentTitle:()=>o,default:()=>m,frontMatter:()=>r,metadata:()=>i,toc:()=>l});var n=s(5893),a=s(1151);const r={slug:"emacs-scheme-regex",title:"Scheme Regex literals in Emacs",authors:"jcubic",tags:["scheme","emacs"]},o=void 0,i={permalink:"/blog/emacs-scheme-regex",editUrl:"https://github.com/jcubic/lips-website/tree/docusaurus/docs/blog/2024-03-09-emacs-regex-literals.md",source:"@site/blog/2024-03-09-emacs-regex-literals.md",title:"Scheme Regex literals in Emacs",description:"LIPS Scheme support regular expression literals, but it's not the only one implementation that",date:"2024-03-09T00:00:00.000Z",formattedDate:"March 9, 2024",tags:[{label:"scheme",permalink:"/blog/tags/scheme"},{label:"emacs",permalink:"/blog/tags/emacs"}],readingTime:1.05,hasTruncateMarker:!0,authors:[{name:"Jakub T. Jankiewicz",title:"LIPS maintainer",url:"https://jakub.jankiewicz.org/",imageURL:"https://github.com/jcubic.png",key:"jcubic"}],frontMatter:{slug:"emacs-scheme-regex",title:"Scheme Regex literals in Emacs",authors:"jcubic",tags:["scheme","emacs"]},unlisted:!1,nextItem:{title:"LIPS History",permalink:"/blog/lips-history"}},c={authorsImageUrls:[void 0]},l=[{value:"The problem",id:"the-problem",level:2},{value:"The solution",id:"the-solution",level:2}];function h(e){const t={a:"a",code:"code",h2:"h2",p:"p",pre:"pre",...(0,a.a)(),...e.components};return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsxs)(t.p,{children:["LIPS Scheme support regular expression literals, but it's not the only one implementation that\nsupport those.  Other implementation includes ",(0,n.jsx)(t.a,{href:"https://practical-scheme.net/gauche/",children:"Gauche"})," and\n",(0,n.jsx)(t.a,{href:"https://www.gnu.org/software/kawa/index.html",children:"Kawa"}),"."]}),"\n",(0,n.jsxs)(t.p,{children:["Unfortunetlly, you can't easily use those regular expressions in ",(0,n.jsx)(t.a,{href:"https://en.wikipedia.org/wiki/GNU_Emacs",children:"GNU\nEmacs"}),", my main editor of choice."]}),"\n",(0,n.jsx)(t.h2,{id:"the-problem",children:"The problem"}),"\n",(0,n.jsxs)(t.p,{children:["The main problem is when using vertical bar character inside Scheme code in Emacs. GNU Emacs thinks\nthat the vertical bar is part of the ",(0,n.jsx)(t.a,{href:"/docs/scheme-intro/data-types#symbols",children:"symbol"}),":"]}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-scheme",children:'(let ((str "foo bar")\n      (re #/foo|bar/)) ;; | ))\n  (str.match re))\n;; ==> #("foo")\n'})}),"\n",(0,n.jsxs)(t.p,{children:["This blog (the same as whole website) use modified PrismJS Scheme mode that supports regular\nexpressions. But in GNU Emacs there was a need to add ",(0,n.jsx)(t.code,{children:"|"})," after a comment and close the lists that\nwere ignored by Emacs scheme mode (because they were inside symbol)."]}),"\n",(0,n.jsx)(t.h2,{id:"the-solution",children:"The solution"}),"\n",(0,n.jsxs)(t.p,{children:["I asked a ",(0,n.jsx)(t.a,{href:"https://lists.gnu.org/archive/html/emacs-devel/2024-02/msg00896.html",children:"question on emacs-devel mailing\nlist"}),", on how to solve this\nproblem. I didn't get any reply for days, then suddenly someone ",(0,n.jsx)(t.a,{href:"https://lists.gnu.org/archive/html/emacs-devel/2024-03/msg00282.html",children:"reply with this emacs lisp code\nsnippet"}),"."]}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lisp",children:'(defun scheme-regex-patch ()\n  (setq-local\n   syntax-propertize-function\n   (lambda (start end)\n     (goto-char start)\n     (funcall\n      (syntax-propertize-rules\n       ;; For #/regexp/ syntax\n       ("\\\\(#\\\\)/\\\\(\\\\\\\\/\\\\|\\\\\\\\\\\\\\\\\\\\|.\\\\)*?\\\\(/\\\\)"\n        (1 "|")\n        (3 "|"))\n       ;; For #; comment syntax\n       ("\\\\(#\\\\);"\n        (1 (prog1 "< cn"\n             (scheme-syntax-propertize-sexp-comment\n              (point) end)))))\n      (point) end))))\n\n(add-hook \'scheme-mode-hook \'scheme-regex-patch)\n'})}),"\n",(0,n.jsx)(t.p,{children:"And this solution works great."})]})}function m(e={}){const{wrapper:t}={...(0,a.a)(),...e.components};return t?(0,n.jsx)(t,{...e,children:(0,n.jsx)(h,{...e})}):h(e)}},1151:(e,t,s)=>{s.d(t,{Z:()=>i,a:()=>o});var n=s(7294);const a={},r=n.createContext(a);function o(e){const t=n.useContext(r);return n.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function i(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(a):e.components||a:o(e.components),n.createElement(r.Provider,{value:t},e.children)}}}]);