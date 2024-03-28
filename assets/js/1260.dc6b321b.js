(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[1260],{9047:(e,t,n)=>{"use strict";n.d(t,{Z:()=>M});var s=n(7294),r=n(5893);function a(e){const{mdxAdmonitionTitle:t,rest:n}=function(e){const t=s.Children.toArray(e),n=t.find((e=>s.isValidElement(e)&&"mdxAdmonitionTitle"===e.type)),a=t.filter((e=>e!==n)),i=n?.props.children;return{mdxAdmonitionTitle:i,rest:a.length>0?(0,r.jsx)(r.Fragment,{children:a}):null}}(e.children),a=e.title??t;return{...e,...a&&{title:a},children:n}}var i=n(512),c=n(5999),o=n(5281);const l={admonition:"admonition_xJq3",admonitionHeading:"admonitionHeading_Gvgb",admonitionIcon:"admonitionIcon_Rf37",admonitionContent:"admonitionContent_BuS1"};function d(e){let{type:t,className:n,children:s}=e;return(0,r.jsx)("div",{className:(0,i.Z)(o.k.common.admonition,o.k.common.admonitionType(t),l.admonition,n),children:s})}function u(e){let{icon:t,title:n}=e;return(0,r.jsxs)("div",{className:l.admonitionHeading,children:[(0,r.jsx)("span",{className:l.admonitionIcon,children:t}),n]})}function m(e){let{children:t}=e;return t?(0,r.jsx)("div",{className:l.admonitionContent,children:t}):null}function h(e){const{type:t,icon:n,title:s,children:a,className:i}=e;return(0,r.jsxs)(d,{type:t,className:i,children:[(0,r.jsx)(u,{title:s,icon:n}),(0,r.jsx)(m,{children:a})]})}function f(e){return(0,r.jsx)("svg",{viewBox:"0 0 14 16",...e,children:(0,r.jsx)("path",{fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"})})}const p={icon:(0,r.jsx)(f,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.note",description:"The default label used for the Note admonition (:::note)",children:"note"})};function x(e){return(0,r.jsx)(h,{...p,...e,className:(0,i.Z)("alert alert--secondary",e.className),children:e.children})}function j(e){return(0,r.jsx)("svg",{viewBox:"0 0 12 16",...e,children:(0,r.jsx)("path",{fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"})})}const v={icon:(0,r.jsx)(j,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.tip",description:"The default label used for the Tip admonition (:::tip)",children:"tip"})};function g(e){return(0,r.jsx)(h,{...v,...e,className:(0,i.Z)("alert alert--success",e.className),children:e.children})}function b(e){return(0,r.jsx)("svg",{viewBox:"0 0 14 16",...e,children:(0,r.jsx)("path",{fillRule:"evenodd",d:"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"})})}const y={icon:(0,r.jsx)(b,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.info",description:"The default label used for the Info admonition (:::info)",children:"info"})};function w(e){return(0,r.jsx)(h,{...y,...e,className:(0,i.Z)("alert alert--info",e.className),children:e.children})}function N(e){return(0,r.jsx)("svg",{viewBox:"0 0 16 16",...e,children:(0,r.jsx)("path",{fillRule:"evenodd",d:"M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"})})}const C={icon:(0,r.jsx)(N,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.warning",description:"The default label used for the Warning admonition (:::warning)",children:"warning"})};function Z(e){return(0,r.jsx)("svg",{viewBox:"0 0 12 16",...e,children:(0,r.jsx)("path",{fillRule:"evenodd",d:"M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z"})})}const k={icon:(0,r.jsx)(Z,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.danger",description:"The default label used for the Danger admonition (:::danger)",children:"danger"})};const E={icon:(0,r.jsx)(N,{}),title:(0,r.jsx)(c.Z,{id:"theme.admonition.caution",description:"The default label used for the Caution admonition (:::caution)",children:"caution"})};const z={...{note:x,tip:g,info:w,warning:function(e){return(0,r.jsx)(h,{...C,...e,className:(0,i.Z)("alert alert--warning",e.className),children:e.children})},danger:function(e){return(0,r.jsx)(h,{...k,...e,className:(0,i.Z)("alert alert--danger",e.className),children:e.children})}},...{secondary:e=>(0,r.jsx)(x,{title:"secondary",...e}),important:e=>(0,r.jsx)(w,{title:"important",...e}),success:e=>(0,r.jsx)(g,{title:"success",...e}),caution:function(e){return(0,r.jsx)(h,{...E,...e,className:(0,i.Z)("alert alert--warning",e.className),children:e.children})}}};function M(e){const t=a(e),n=(s=t.type,z[s]||(console.warn(`No admonition component found for admonition type "${s}". Using Info as fallback.`),z.info));var s;return(0,r.jsx)(n,{...t})}},345:(e,t,n)=>{"use strict";n.d(t,{Z:()=>r});n(7294);var s=n(5893);function r(e){return(0,s.jsx)("svg",{viewBox:"0 0 24 24",...e,children:(0,s.jsx)("path",{fill:"currentColor",d:"M19,21H8V7H19M19,5H8A2,2 0 0,0 6,7V21A2,2 0 0,0 8,23H19A2,2 0 0,0 21,21V7A2,2 0 0,0 19,5M16,1H4A2,2 0 0,0 2,3V17H4V3H16V1Z"})})}},7666:(e,t,n)=>{"use strict";n.d(t,{Z:()=>r});n(7294);var s=n(5893);function r(e){return(0,s.jsx)("svg",{viewBox:"0 0 24 24",...e,children:(0,s.jsx)("path",{fill:"currentColor",d:"M21,7L9,19L3.5,13.5L4.91,12.09L9,16.17L19.59,5.59L21,7Z"})})}},670:(e,t,n)=>{"use strict";n.d(t,{Z:()=>r});n(7294);var s=n(5893);function r(e){return(0,s.jsx)("svg",{viewBox:"0 0 24 24",...e,children:(0,s.jsx)("path",{fill:"currentColor",d:"M4 19h6v-2H4v2zM20 5H4v2h16V5zm-3 6H4v2h13.25c1.1 0 2 .9 2 2s-.9 2-2 2H15v-2l-3 3l3 3v-2h2c2.21 0 4-1.79 4-4s-1.79-4-4-4z"})})}},9265:(e,t,n)=>{"use strict";n.d(t,{Z:()=>M});var s=n(7294),r=n(1151),a=n(5742),i=n(3155),c=n(5893);function o(e){return(0,c.jsx)("code",{...e})}var l=n(3692);var d=n(512),u=n(2389),m=n(6043);const h={details:"details_lb9f",isBrowser:"isBrowser_bmU9",collapsibleContent:"collapsibleContent_i85q"};function f(e){return!!e&&("SUMMARY"===e.tagName||f(e.parentElement))}function p(e,t){return!!e&&(e===t||p(e.parentElement,t))}function x(e){let{summary:t,children:n,...r}=e;const a=(0,u.Z)(),i=(0,s.useRef)(null),{collapsed:o,setCollapsed:l}=(0,m.u)({initialState:!r.open}),[x,j]=(0,s.useState)(r.open),v=s.isValidElement(t)?t:(0,c.jsx)("summary",{children:t??"Details"});return(0,c.jsxs)("details",{...r,ref:i,open:x,"data-collapsed":o,className:(0,d.Z)(h.details,a&&h.isBrowser,r.className),onMouseDown:e=>{f(e.target)&&e.detail>1&&e.preventDefault()},onClick:e=>{e.stopPropagation();const t=e.target;f(t)&&p(t,i.current)&&(e.preventDefault(),o?(l(!1),j(!0)):l(!0))},children:[v,(0,c.jsx)(m.z,{lazy:!1,collapsed:o,disableSSRStyle:!0,onCollapseTransitionEnd:e=>{l(e),j(!e)},children:(0,c.jsx)("div",{className:h.collapsibleContent,children:n})})]})}const j={details:"details_b_Ee"},v="alert alert--info";function g(e){let{...t}=e;return(0,c.jsx)(x,{...t,className:(0,d.Z)(v,j.details,t.className)})}function b(e){const t=s.Children.toArray(e.children),n=t.find((e=>s.isValidElement(e)&&"summary"===e.type)),r=(0,c.jsx)(c.Fragment,{children:t.filter((e=>e!==n))});return(0,c.jsx)(g,{...e,summary:n,children:r})}var y=n(2503);function w(e){return(0,c.jsx)(y.Z,{...e})}const N={containsTaskList:"containsTaskList_mC6p"};function C(e){if(void 0!==e)return(0,d.Z)(e,e?.includes("contains-task-list")&&N.containsTaskList)}const Z={img:"img_ev3q"};var k=n(9047),E=n(1875);const z={Head:a.Z,details:b,Details:b,code:function(e){return function(e){return void 0!==e.children&&s.Children.toArray(e.children).every((e=>"string"==typeof e&&!e.includes("\n")))}(e)?(0,c.jsx)(o,{...e}):(0,c.jsx)(i.Z,{...e})},a:function(e){return(0,c.jsx)(l.Z,{...e})},pre:function(e){return(0,c.jsx)(c.Fragment,{children:e.children})},ul:function(e){return(0,c.jsx)("ul",{...e,className:C(e.className)})},img:function(e){return(0,c.jsx)("img",{loading:"lazy",...e,className:(t=e.className,(0,d.Z)(t,Z.img))});var t},h1:e=>(0,c.jsx)(w,{as:"h1",...e}),h2:e=>(0,c.jsx)(w,{as:"h2",...e}),h3:e=>(0,c.jsx)(w,{as:"h3",...e}),h4:e=>(0,c.jsx)(w,{as:"h4",...e}),h5:e=>(0,c.jsx)(w,{as:"h5",...e}),h6:e=>(0,c.jsx)(w,{as:"h6",...e}),admonition:k.Z,mermaid:E.Z};function M(e){let{children:t}=e;return(0,c.jsx)(r.Z,{components:z,children:t})}},5448:(e,t,n)=>{"use strict";n.d(t,{F:()=>c});var s=n(7294),r=n(902);const a={attributes:!0,characterData:!0,childList:!0,subtree:!0};function i(e,t){const[n,i]=(0,s.useState)(),c=(0,s.useCallback)((()=>{i(e.current?.closest("[role=tabpanel][hidden]"))}),[e,i]);(0,s.useEffect)((()=>{c()}),[c]),function(e,t,n){void 0===n&&(n=a);const i=(0,r.zX)(t),c=(0,r.Ql)(n);(0,s.useEffect)((()=>{const t=new MutationObserver(i);return e&&t.observe(e,c),()=>t.disconnect()}),[e,i,c])}(n,(e=>{e.forEach((e=>{"attributes"===e.type&&"hidden"===e.attributeName&&(t(),c())}))}),{attributes:!0,characterData:!1,childList:!1,subtree:!1})}function c(){const[e,t]=(0,s.useState)(!1),[n,r]=(0,s.useState)(!1),a=(0,s.useRef)(null),c=(0,s.useCallback)((()=>{const n=a.current.querySelector("code");e?n.removeAttribute("style"):(n.style.whiteSpace="pre-wrap",n.style.overflowWrap="anywhere"),t((e=>!e))}),[a,e]),o=(0,s.useCallback)((()=>{const{scrollWidth:e,clientWidth:t}=a.current,n=e>t||a.current.querySelector("code").hasAttribute("style");r(n)}),[a]);return i(a,o),(0,s.useEffect)((()=>{o()}),[e,o]),(0,s.useEffect)((()=>(window.addEventListener("resize",o,{passive:!0}),()=>{window.removeEventListener("resize",o)})),[o]),{codeBlockRef:a,isEnabled:e,isCodeScrollable:n,toggle:c}}},6412:(e,t,n)=>{"use strict";n.d(t,{p:()=>a});var s=n(2949),r=n(6668);function a(){const{prism:e}=(0,r.L)(),{colorMode:t}=(0,s.I)(),n=e.theme,a=e.darkTheme||n;return"dark"===t?a:n}},7016:(e,t,n)=>{"use strict";n.d(t,{Vo:()=>h,bc:()=>u,nZ:()=>f,nt:()=>m});var s=n(7594),r=n.n(s);const a=/title=(?<quote>["'])(?<title>.*?)\1/,i=/\{(?<range>[\d,-]+)\}/,c={js:{start:"\\/\\/",end:""},jsBlock:{start:"\\/\\*",end:"\\*\\/"},jsx:{start:"\\{\\s*\\/\\*",end:"\\*\\/\\s*\\}"},bash:{start:"#",end:""},html:{start:"\x3c!--",end:"--\x3e"}},o={...c,lua:{start:"--",end:""},wasm:{start:"\\;\\;",end:""},tex:{start:"%",end:""},vb:{start:"['\u2018\u2019]",end:""},rem:{start:"[Rr][Ee][Mm]\\b",end:""},f90:{start:"!",end:""},ml:{start:"\\(\\*",end:"\\*\\)"},cobol:{start:"\\*>",end:""}},l=Object.keys(c);function d(e,t){const n=e.map((e=>{const{start:n,end:s}=o[e];return`(?:${n}\\s*(${t.flatMap((e=>[e.line,e.block?.start,e.block?.end].filter(Boolean))).join("|")})\\s*${s})`})).join("|");return new RegExp(`^\\s*(?:${n})\\s*$`)}function u(e){return e?.match(a)?.groups.title??""}function m(e){return Boolean(e?.includes("showLineNumbers"))}function h(e){const t=e.split(" ").find((e=>e.startsWith("language-")));return t?.replace(/language-/,"")}function f(e,t){let n=e.replace(/\n$/,"");const{language:s,magicComments:a,metastring:c}=t;if(c&&i.test(c)){const e=c.match(i).groups.range;if(0===a.length)throw new Error(`A highlight range has been given in code block's metastring (\`\`\` ${c}), but no magic comment config is available. Docusaurus applies the first magic comment entry's className for metastring ranges.`);const t=a[0].className,s=r()(e).filter((e=>e>0)).map((e=>[e-1,[t]]));return{lineClassNames:Object.fromEntries(s),code:n}}if(void 0===s)return{lineClassNames:{},code:n};const o=function(e,t){switch(e){case"js":case"javascript":case"ts":case"typescript":return d(["js","jsBlock"],t);case"jsx":case"tsx":return d(["js","jsBlock","jsx"],t);case"html":return d(["js","jsBlock","html"],t);case"python":case"py":case"bash":return d(["bash"],t);case"markdown":case"md":return d(["html","jsx","bash"],t);case"tex":case"latex":case"matlab":return d(["tex"],t);case"lua":case"haskell":case"sql":return d(["lua"],t);case"wasm":return d(["wasm"],t);case"vb":case"vbnet":case"vba":case"visual-basic":return d(["vb","rem"],t);case"batch":return d(["rem"],t);case"basic":return d(["rem","f90"],t);case"fsharp":return d(["js","ml"],t);case"ocaml":case"sml":return d(["ml"],t);case"fortran":return d(["f90"],t);case"cobol":return d(["cobol"],t);default:return d(l,t)}}(s,a),u=n.split("\n"),m=Object.fromEntries(a.map((e=>[e.className,{start:0,range:""}]))),h=Object.fromEntries(a.filter((e=>e.line)).map((e=>{let{className:t,line:n}=e;return[n,t]}))),f=Object.fromEntries(a.filter((e=>e.block)).map((e=>{let{className:t,block:n}=e;return[n.start,t]}))),p=Object.fromEntries(a.filter((e=>e.block)).map((e=>{let{className:t,block:n}=e;return[n.end,t]})));for(let r=0;r<u.length;){const e=u[r].match(o);if(!e){r+=1;continue}const t=e.slice(1).find((e=>void 0!==e));h[t]?m[h[t]].range+=`${r},`:f[t]?m[f[t]].start=r:p[t]&&(m[p[t]].range+=`${m[p[t]].start}-${r-1},`),u.splice(r,1)}n=u.join("\n");const x={};return Object.entries(m).forEach((e=>{let[t,{range:n}]=e;r()(n).forEach((e=>{x[e]??=[],x[e].push(t)}))})),{lineClassNames:x,code:n}}},7594:(e,t)=>{function n(e){let t,n=[];for(let s of e.split(",").map((e=>e.trim())))if(/^-?\d+$/.test(s))n.push(parseInt(s,10));else if(t=s.match(/^(-?\d+)(-|\.\.\.?|\u2025|\u2026|\u22EF)(-?\d+)$/)){let[e,s,r,a]=t;if(s&&a){s=parseInt(s),a=parseInt(a);const e=s<a?1:-1;"-"!==r&&".."!==r&&"\u2025"!==r||(a+=e);for(let t=s;t!==a;t+=e)n.push(t)}}return n}t.default=n,e.exports=n},1151:(e,t,n)=>{"use strict";n.d(t,{Z:()=>c,a:()=>i});var s=n(7294);const r={},a=s.createContext(r);function i(e){const t=s.useContext(a);return s.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function c(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:i(e.components),s.createElement(a.Provider,{value:t},e.children)}},195:(e,t,n)=>{"use strict";function s(e,t){let{target:n=document.body}=void 0===t?{}:t;if("string"!=typeof e)throw new TypeError(`Expected parameter \`text\` to be a \`string\`, got \`${typeof e}\`.`);const s=document.createElement("textarea"),r=document.activeElement;s.value=e,s.setAttribute("readonly",""),s.style.contain="strict",s.style.position="absolute",s.style.left="-9999px",s.style.fontSize="12pt";const a=document.getSelection(),i=a.rangeCount>0&&a.getRangeAt(0);n.append(s),s.select(),s.selectionStart=0,s.selectionEnd=e.length;let c=!1;try{c=document.execCommand("copy")}catch{}return s.remove(),i&&(a.removeAllRanges(),a.addRange(i)),r&&r.focus(),c}n.d(t,{Z:()=>s})}}]);