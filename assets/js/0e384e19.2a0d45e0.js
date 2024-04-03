"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[9671],{7876:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>c,contentTitle:()=>a,default:()=>h,frontMatter:()=>r,metadata:()=>o,toc:()=>l});var t=s(5893),i=s(1151);const r={sidebar_position:1},a="Getting Started",o={id:"intro",title:"Getting Started",description:"Browser",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/docs/intro",draft:!1,unlisted:!1,editUrl:"https://github.com/LIPS-scheme/lips/tree/master/docs/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"tutorialSidebar",next:{title:"Introduction to Scheme",permalink:"/docs/category/introduction-to-scheme"}},c={},l=[{value:"Browser",id:"browser",level:2},{value:"Running Scheme Code Inline",id:"running-scheme-code-inline",level:3},{value:"Running External Scheme Code",id:"running-external-scheme-code",level:3},{value:"Node.js",id:"nodejs",level:2},{value:"Executing files",id:"executing-files",level:3},{value:"Executing expressions",id:"executing-expressions",level:3},{value:"Standalone scripts",id:"standalone-scripts",level:3},{value:"Node.js project",id:"nodejs-project",level:3},{value:"Executing LIPS prammatically",id:"executing-lips-prammatically",level:2},{value:"Creating REPL",id:"creating-repl",level:3},{value:"Bootstrapping",id:"bootstrapping",level:3},{value:"Editor support",id:"editor-support",level:2}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",h3:"h3",img:"img",p:"p",pre:"pre",strong:"strong",...(0,i.a)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"getting-started",children:"Getting Started"}),"\n",(0,t.jsx)(n.h2,{id:"browser",children:"Browser"}),"\n",(0,t.jsx)(n.p,{children:"When using LIPS Scheme interpreter in browser you need to include the main script file."}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-html",children:'<script src="https://unpkg.com/@jcubic/lips@beta/dist/lips.min.js"><\/script>\n'})}),"\n",(0,t.jsxs)(n.p,{children:["or ",(0,t.jsx)(n.a,{href:"https://www.jsdelivr.com/",children:"jsDelivr"})," that is somewhat faster:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-html",children:'<script src="https://cdn.jsdelivr.net/npm/@jcubic/lips@beta/dist/lips.min.js"><\/script>\n'})}),"\n",(0,t.jsx)(n.p,{children:"After adding script tag with main file, you can use Scheme code inside script tag:"}),"\n",(0,t.jsx)(n.h3,{id:"running-scheme-code-inline",children:"Running Scheme Code Inline"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-html",children:'<script type="text/x-scheme" bootstrap>\n(let ((what "world")\n      (greet "hello"))\n   (display (string-append "hello" " " what))\n   (newline))\n<\/script>\n'})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"NOTE"}),": Only the core of LIPS is written in JavaScript, almost half of it it's written in Scheme.\nSo if you want to load the standard library (to have full LIPS), you should use ",(0,t.jsx)(n.code,{children:"bootstrap"})," or\n",(0,t.jsx)(n.code,{children:"data-bootstrap"})," attribute that will load it for you. You can optionally specify the location of the\nfile."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-html",children:'<script type="text/x-scheme" bootstrap="https://cdn.jsdelivr.net/npm/@jcubic/lips@beta/dist/std.xcb">\n(let ((what "world")\n      (greet "hello"))\n   (display (string-append "hello" " " what))\n   (newline))\n<\/script>\n'})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"xcb"})," file is simple binary format that LIPS uses to speed up parsing the the code. You can also use\n",(0,t.jsx)(n.code,{children:".scm"})," file or ",(0,t.jsx)(n.code,{children:".min.scm"})," file that may be little bit bigger."]}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"NOTE"})," The ",(0,t.jsx)(n.code,{children:"bootstrap"})," attribute can also be included on main script tag with the JavaScript file."]}),"\n",(0,t.jsx)(n.h3,{id:"running-external-scheme-code",children:"Running External Scheme Code"}),"\n",(0,t.jsxs)(n.p,{children:["You can also use ",(0,t.jsx)(n.code,{children:"src"})," attribute to link to source file. Like you normally do with JavaScript:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-html",children:'<script type="text/x-scheme" src="example.scm"><script>\n'})}),"\n",(0,t.jsx)(n.h2,{id:"nodejs",children:"Node.js"}),"\n",(0,t.jsx)(n.p,{children:"To install LIPS you can use NPM:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"npm install -g @jcubic/lips@beta\n"})}),"\n",(0,t.jsx)(n.p,{children:"You should use beta, because the so call stable version is really old and outdated. Because of so many\nbreaking changes no new stable version was released and instead 1.0 beta started."}),"\n",(0,t.jsxs)(n.p,{children:["If LIPS is installed globally just use ",(0,t.jsx)(n.code,{children:"lips"})," command to start the REPL:"]}),"\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.img,{alt:"LIPS REPL session in Terminal",src:s(5608).Z+"",width:"791",height:"455"})}),"\n",(0,t.jsxs)(n.p,{children:["By default, splash screen is shown you can hide it with option ",(0,t.jsx)(n.code,{children:"-q"}),". If you're using bash you can create an\nalias:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"alias lips='lips -q'\n"})}),"\n",(0,t.jsx)(n.p,{children:"and you will not see the splash again."}),"\n",(0,t.jsx)(n.h3,{id:"executing-files",children:"Executing files"}),"\n",(0,t.jsx)(n.p,{children:"You can also execute scheme code with:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"lips foo.scm\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Note, that with lisp executable you don't need to manually bootstrap the standard library. But you can change\nwhich file is loaded or disable the loading of the file completely using ",(0,t.jsx)(n.code,{children:"--bootstrap"})," flag."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"lips --bootstrap dist/std.scm foo.scm\n"})}),"\n",(0,t.jsx)(n.p,{children:"This will run foo.scm file and bootstrap from main scheme file."}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"lips --bootstrap none foo.scm\n"})}),"\n",(0,t.jsx)(n.p,{children:"This will run the code without loading the standard library. So LIPS will have only functions\nand macros defined in JavaScript. This is called Core of LIPS with most of the essentials."}),"\n",(0,t.jsx)(n.h3,{id:"executing-expressions",children:"Executing expressions"}),"\n",(0,t.jsxs)(n.p,{children:["You can execute expression with ",(0,t.jsx)(n.code,{children:"-e"})," flag (short of ",(0,t.jsx)(n.code,{children:"eval"}),"):"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"lips -e '(print \"hello world\")'\n"})}),"\n",(0,t.jsx)(n.h3,{id:"standalone-scripts",children:"Standalone scripts"}),"\n",(0,t.jsxs)(n.p,{children:["You can also write scripts using LIPS with ",(0,t.jsx)(n.a,{href:"https://en.wikipedia.org/wiki/Shebang_(Unix)",children:"shebang"}),".\nThis extension is defined in ",(0,t.jsx)(n.a,{href:"https://srfi.schemers.org/srfi-22/srfi-22.html",children:"SRFI-22"}),"."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:'#!/usr/bin/env lips\n(let ((what "World"))\n  (print (string-append "Hello " what)))\n'})}),"\n",(0,t.jsxs)(n.p,{children:["If you write code like this and save it in ",(0,t.jsx)(n.code,{children:"script.scm"})," on Unix like systems (Linux, macOS, or Windows with WSL)\nyou can change the execution permission:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"chmod +x script.scm\n"})}),"\n",(0,t.jsx)(n.p,{children:"and execute the script by providing the name:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"./script.scm\n"})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"NOTE"}),": by default most systems don't execute files in current directory so you need to provide ",(0,t.jsx)(n.code,{children:"./"})," in front.\nYou can change that if you add dot (current working directory) to the ",(0,t.jsx)(n.code,{children:"$PATH"})," environment variable:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:'export $PATH=".:$PATH"\n'})}),"\n",(0,t.jsx)(n.p,{children:"If you prefer to install lips locally instead of globally you can use this shebang:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:'#!/usr/bin/env -S npx @jcubic/lips\n(let ((what "World"))\n  (print (string-append "Hello " what)))\n'})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"NOTE"}),": if you run this code outside of ",(0,t.jsx)(n.a,{href:"#nodejs-project",children:"Node.js project"})," npx will install the\npackage before execution."]}),"\n",(0,t.jsx)(n.h3,{id:"nodejs-project",children:"Node.js project"}),"\n",(0,t.jsxs)(n.p,{children:["Afeter you have installed LIPS you can create a new Node.js project and write LIPS Scheme code\ninstead of JavaScript, using everything Node.js provides. See documentation about ",(0,t.jsx)(n.a,{href:"/docs/lips/intro#integration-with-javascript",children:"Integration with\nJavaScript"}),"."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"mkdir my-project\ncd my-project\nnpm init -y\n"})}),"\n",(0,t.jsx)(n.p,{children:"Then you can install npm packages"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"npm install braces\n"})}),"\n",(0,t.jsx)(n.p,{children:"and use them in LIPS Scheme:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-scheme",children:'(define braces (require "braces"))\n\n(write (braces "{01..10}" &(:expand #t)))\n;; ==> #("01" "02" "03" "04" "05" "06" "07" "08" "09" "10")\n'})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"NOTE"}),": ",(0,t.jsx)(n.a,{href:"https://www.npmjs.com/package/braces",children:"braces"})," is a popular package to expand bash like\nexpressions, it's used as ",(0,t.jsx)(n.a,{href:"https://shubhamjain.co/2024/02/29/why-is-number-package-have-59m-downloads/",children:"deep dependency for\nTailwindCSS"}),"."]}),"\n",(0,t.jsx)(n.h2,{id:"executing-lips-prammatically",children:"Executing LIPS prammatically"}),"\n",(0,t.jsx)(n.p,{children:"You can also execute LIPS from JavaScript:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-javascript",children:"const { exec } = require('@jcubic/lips');\n// or\nimport { exec } from '@jcubic/lips';\n\nexec('(let ((a 10) (b 20)) (* a b))').then(result => {\n    results.forEach(function(result) {\n        if (typeof result !== 'undefined') {\n            console.log(result.toString());\n        }\n    });\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"exec"})," is the main function that can be used to evaluate expressions. It returns a Promise of Array\nof results."]}),"\n",(0,t.jsx)(n.h3,{id:"creating-repl",children:"Creating REPL"}),"\n",(0,t.jsx)(n.p,{children:"If you want to create REPL or similar thing you can use Interpreter interface which allow to change\nstdin and stdout."}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-javascript",children:"import { Interpreter, InputPort, OutputPort } from '@jcubic/lips';\n\nconst interpreter = Interpreter('<name>', {\n    stdin: InputPort(function() {\n        return new Promise(function(resolve) {\n          // resolve with a string when data is ready\n        });\n    },\n    stdout: OutputPort(function(obj) {\n        // you will get any object and need to print it\n        // you can use this.get('repr') function from LIPS environment\n        // to get representation of the object as string\n        if (typeof obj !== 'string') {\n            obj = this.get('repr')(obj);\n        }\n    })\n});\n"})}),"\n",(0,t.jsx)(n.p,{children:"Anything you add to the object passed to Interpreter will be added to global scope."}),"\n",(0,t.jsxs)(n.p,{children:["The Interpreter have a method ",(0,t.jsx)(n.code,{children:"exec"})," that work the same as thhe one exported from LIPS."]}),"\n",(0,t.jsx)(n.h3,{id:"bootstrapping",children:"Bootstrapping"}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"Note"}),": that you also need to bootstrap the standard library to have fully working Scheme system."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-javascript",children:'await interpreter.exec(`(let-env lips.env.__parent__\n                          (load "<path or URL>/dist/std.xcb"))`);\n'})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"lips.env"})," is user environment and ",(0,t.jsx)(n.code,{children:"__parent__"})," is real top level global environment.  To see more\nabout ",(0,t.jsx)(n.code,{children:"let-env"})," expression check ",(0,t.jsx)(n.a,{href:"/docs/lips/environments",children:"documentation about LIPS environments"}),"."]}),"\n",(0,t.jsx)(n.h2,{id:"editor-support",children:"Editor support"}),"\n",(0,t.jsxs)(n.p,{children:["Note that Scheme is popular language and editors usually support its syntax. But also not every editor\nmay support literal regular expressions that are part of LIPS. If your editor doesn't support them,\nyou can report an issue if the project is Open Source. Literal Regular Expressions are also part\nof ",(0,t.jsx)(n.a,{href:"https://practical-scheme.net/gauche/man/gauche-refe/Regular-expressions.html",children:"Gauche"})," and\n",(0,t.jsx)(n.a,{href:"https://www.gnu.org/software/kawa/Regular-expressions.html",children:"GNU Kawa"}),"."]})]})}function h(e={}){const{wrapper:n}={...(0,i.a)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(d,{...e})}):d(e)}},5608:(e,n,s)=>{s.d(n,{Z:()=>t});const t=s.p+"assets/images/screencast-42458b39bea26c02ed7c9b889c261d8b.gif"},1151:(e,n,s)=>{s.d(n,{Z:()=>o,a:()=>a});var t=s(7294);const i={},r=t.createContext(i);function a(e){const n=t.useContext(r);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:a(e.components),t.createElement(r.Provider,{value:n},e.children)}}}]);