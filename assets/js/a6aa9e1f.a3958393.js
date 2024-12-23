"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[7643],{5124:(e,t,n)=>{n.r(t),n.d(t,{default:()=>b});n(6540);var o=n(4164),s=n(4586),a=n(1213),r=n(7559),l=n(8027),c=n(7713),i=n(1463),d=n(3892),u=n(5260),m=n(4096),g=n(4848);function p(e){const t=(0,m.kJ)(e);return(0,g.jsx)(u.A,{children:(0,g.jsx)("script",{type:"application/ld+json",children:JSON.stringify(t)})})}function h(e){const{metadata:t}=e,{siteConfig:{title:n}}=(0,s.A)(),{blogDescription:o,blogTitle:r,permalink:l}=t,c="/"===l?n:r;return(0,g.jsxs)(g.Fragment,{children:[(0,g.jsx)(a.be,{title:c,description:o}),(0,g.jsx)(i.A,{tag:"blog_posts_list"})]})}function x(e){const{metadata:t,items:n,sidebar:o}=e;return(0,g.jsxs)(l.A,{sidebar:o,children:[(0,g.jsx)(d.A,{items:n}),(0,g.jsx)(c.A,{metadata:t})]})}function b(e){return(0,g.jsxs)(a.e3,{className:(0,o.A)(r.G.wrapper.blogPages,r.G.page.blogListPage),children:[(0,g.jsx)(h,{...e}),(0,g.jsx)(p,{...e}),(0,g.jsx)(x,{...e})]})}},7713:(e,t,n)=>{n.d(t,{A:()=>r});n(6540);var o=n(1312),s=n(9022),a=n(4848);function r(e){const{metadata:t}=e,{previousPage:n,nextPage:r}=t;return(0,a.jsxs)("nav",{className:"pagination-nav","aria-label":(0,o.T)({id:"theme.blog.paginator.navAriaLabel",message:"Blog list page navigation",description:"The ARIA label for the blog pagination"}),children:[n&&(0,a.jsx)(s.A,{permalink:n,title:(0,a.jsx)(o.A,{id:"theme.blog.paginator.newerEntries",description:"The label used to navigate to the newer blog posts page (previous page)",children:"Newer entries"})}),r&&(0,a.jsx)(s.A,{permalink:r,title:(0,a.jsx)(o.A,{id:"theme.blog.paginator.olderEntries",description:"The label used to navigate to the older blog posts page (next page)",children:"Older entries"}),isNext:!0})]})}},2907:(e,t,n)=>{n.d(t,{A:()=>P});n(6540);var o=n(4164),s=n(4096),a=n(4848);function r(e){let{children:t,className:n}=e;return(0,a.jsx)("article",{className:n,children:t})}var l=n(8774);const c={title:"title_f1Hy"};function i(e){let{className:t}=e;const{metadata:n,isBlogPostPage:r}=(0,s.e7)(),{permalink:i,title:d}=n,u=r?"h1":"h2";return(0,a.jsx)(u,{className:(0,o.A)(c.title,t),children:r?d:(0,a.jsx)(l.A,{to:i,children:d})})}var d=n(1312),u=n(5846),m=n(6266);const g={container:"container_mt6G"};function p(e){let{readingTime:t}=e;const n=function(){const{selectMessage:e}=(0,u.W)();return t=>{const n=Math.ceil(t);return e(n,(0,d.T)({id:"theme.blog.post.readingTime.plurals",description:'Pluralized label for "{readingTime} min read". Use as much plural forms (separated by "|") as your language support (see https://www.unicode.org/cldr/cldr-aux/charts/34/supplemental/language_plural_rules.html)',message:"One min read|{readingTime} min read"},{readingTime:n}))}}();return(0,a.jsx)(a.Fragment,{children:n(t)})}function h(e){let{date:t,formattedDate:n}=e;return(0,a.jsx)("time",{dateTime:t,children:n})}function x(){return(0,a.jsx)(a.Fragment,{children:" \xb7 "})}function b(e){let{className:t}=e;const{metadata:n}=(0,s.e7)(),{date:r,readingTime:l}=n,c=(0,m.i)({day:"numeric",month:"long",year:"numeric",timeZone:"UTC"});return(0,a.jsxs)("div",{className:(0,o.A)(g.container,"margin-vert--md",t),children:[(0,a.jsx)(h,{date:r,formattedDate:(i=r,c.format(new Date(i)))}),void 0!==l&&(0,a.jsxs)(a.Fragment,{children:[(0,a.jsx)(x,{}),(0,a.jsx)(p,{readingTime:l})]})]});var i}var j=n(6913);const f={authorCol:"authorCol_Hf19",imageOnlyAuthorRow:"imageOnlyAuthorRow_pa_O",imageOnlyAuthorCol:"imageOnlyAuthorCol_G86a"};function A(e){let{className:t}=e;const{metadata:{authors:n},assets:r}=(0,s.e7)();if(0===n.length)return null;const l=n.every((e=>{let{name:t}=e;return!t})),c=1===n.length;return(0,a.jsx)("div",{className:(0,o.A)("margin-top--md margin-bottom--sm",l?f.imageOnlyAuthorRow:"row",t),children:n.map(((e,t)=>(0,a.jsx)("div",{className:(0,o.A)(!l&&(c?"col col--12":"col col--6"),l?f.imageOnlyAuthorCol:f.authorCol),children:(0,a.jsx)(j.A,{author:{...e,imageURL:r.authorsImageUrls[t]??e.imageURL}})},t)))})}function N(){return(0,a.jsxs)("header",{children:[(0,a.jsx)(i,{}),(0,a.jsx)(b,{}),(0,a.jsx)(A,{})]})}var k=n(440),B=n(5425);function y(e){let{children:t,className:n}=e;const{isBlogPostPage:r}=(0,s.e7)();return(0,a.jsx)("div",{id:r?k.LU:void 0,className:(0,o.A)("markdown",n),children:(0,a.jsx)(B.A,{children:t})})}var v=n(7559),w=n(4336),T=n(4434);function C(){return(0,a.jsx)("b",{children:(0,a.jsx)(d.A,{id:"theme.blog.post.readMore",description:"The label used in blog post item excerpts to link to full blog posts",children:"Read more"})})}function _(e){const{blogPostTitle:t,...n}=e;return(0,a.jsx)(l.A,{"aria-label":(0,d.T)({message:"Read more about {title}",id:"theme.blog.post.readMoreLabel",description:"The ARIA label for the link to full blog posts from excerpts"},{title:t}),...n,children:(0,a.jsx)(C,{})})}function L(){const{metadata:e,isBlogPostPage:t}=(0,s.e7)(),{tags:n,title:r,editUrl:l,hasTruncateMarker:c,lastUpdatedBy:i,lastUpdatedAt:d}=e,u=!t&&c,m=n.length>0;if(!(m||u||l))return null;if(t){const e=!!(l||d||i);return(0,a.jsxs)("footer",{className:"docusaurus-mt-lg",children:[m&&(0,a.jsx)("div",{className:(0,o.A)("row","margin-top--sm",v.G.blog.blogFooterEditMetaRow),children:(0,a.jsx)("div",{className:"col",children:(0,a.jsx)(T.A,{tags:n})})}),e&&(0,a.jsx)(w.A,{className:(0,o.A)("margin-top--sm",v.G.blog.blogFooterEditMetaRow),editUrl:l,lastUpdatedAt:d,lastUpdatedBy:i})]})}return(0,a.jsxs)("footer",{className:"row docusaurus-mt-lg",children:[m&&(0,a.jsx)("div",{className:(0,o.A)("col",{"col--9":u}),children:(0,a.jsx)(T.A,{tags:n})}),u&&(0,a.jsx)("div",{className:(0,o.A)("col text--right",{"col--3":m}),children:(0,a.jsx)(_,{blogPostTitle:r,to:e.permalink})})]})}function P(e){let{children:t,className:n}=e;const l=function(){const{isBlogPostPage:e}=(0,s.e7)();return e?void 0:"margin-bottom--xl"}();return(0,a.jsxs)(r,{className:(0,o.A)(l,n),children:[(0,a.jsx)(N,{}),(0,a.jsx)(y,{children:t}),(0,a.jsx)(L,{})]})}},3892:(e,t,n)=>{n.d(t,{A:()=>r});n(6540);var o=n(4096),s=n(2907),a=n(4848);function r(e){let{items:t,component:n=s.A}=e;return(0,a.jsx)(a.Fragment,{children:t.map((e=>{let{content:t}=e;return(0,a.jsx)(o.in,{content:t,children:(0,a.jsx)(n,{children:(0,a.jsx)(t,{})})},t.metadata.permalink)}))})}},1202:(e,t,n)=>{n.d(t,{A:()=>_});var o=n(6540),s=n(2303),a=n(4164),r=n(7559);const l={codeBlockContainer:"codeBlockContainer_APcc"};var c=n(4848);function i(e){let{as:t,...n}=e;return(0,c.jsx)(t,{...n,className:(0,a.A)(n.className,l.codeBlockContainer,r.G.common.codeBlock)})}const d={codeBlockContent:"codeBlockContent_m3Ux",codeBlockTitle:"codeBlockTitle_P25_",codeBlock:"codeBlock_qGQc",codeBlockStandalone:"codeBlockStandalone_zC50",codeBlockLines:"codeBlockLines_p187",codeBlockLinesWithNumbering:"codeBlockLinesWithNumbering_OFgW",buttonGroup:"buttonGroup_6DOT"};function u(e){let{children:t,className:n}=e;return(0,c.jsx)(i,{as:"pre",tabIndex:0,className:(0,a.A)(d.codeBlockStandalone,"thin-scrollbar",n),children:(0,c.jsx)("code",{className:d.codeBlockLines,children:t})})}var m=n(6342),g=n(6058),p=n(4291),h=n(6591),x=n(1765);const b={codeLine:"codeLine_iPqp",codeLineNumber:"codeLineNumber_F4P7",codeLineContent:"codeLineContent_pOih"};function j(e){let{line:t,classNames:n,showLineNumbers:o,getLineProps:s,getTokenProps:r}=e;1===t.length&&"\n"===t[0].content&&(t[0].content="");const l=s({line:t,className:(0,a.A)(n,o&&b.codeLine)}),i=t.map(((e,t)=>{const{key:n,...o}=r({token:e,key:t});return(0,c.jsx)("span",{...o},n)}));return(0,c.jsxs)("span",{...l,children:[o?(0,c.jsxs)(c.Fragment,{children:[(0,c.jsx)("span",{className:b.codeLineNumber}),(0,c.jsx)("span",{className:b.codeLineContent,children:i})]}):i,"\n"]})}var f=n(6861),A=n(1312),N=n(1473),k=n(4115);const B={copyButtonCopied:"copyButtonCopied__QnY",copyButtonIcons:"copyButtonIcons_FhaS",copyButtonIcon:"copyButtonIcon_phi_",copyButtonSuccessIcon:"copyButtonSuccessIcon_FfTR"};function y(e){let{code:t,className:n}=e;const[s,r]=(0,o.useState)(!1),l=(0,o.useRef)(void 0),i=(0,o.useCallback)((()=>{(0,f.A)(t),r(!0),l.current=window.setTimeout((()=>{r(!1)}),1e3)}),[t]);return(0,o.useEffect)((()=>()=>window.clearTimeout(l.current)),[]),(0,c.jsx)("button",{type:"button","aria-label":s?(0,A.T)({id:"theme.CodeBlock.copied",message:"Copied",description:"The copied button label on code blocks"}):(0,A.T)({id:"theme.CodeBlock.copyButtonAriaLabel",message:"Copy code to clipboard",description:"The ARIA label for copy code blocks button"}),title:(0,A.T)({id:"theme.CodeBlock.copy",message:"Copy",description:"The copy button label on code blocks"}),className:(0,a.A)("clean-btn",n,B.copyButton,s&&B.copyButtonCopied),onClick:i,children:(0,c.jsxs)("span",{className:B.copyButtonIcons,"aria-hidden":"true",children:[(0,c.jsx)(N.A,{className:B.copyButtonIcon}),(0,c.jsx)(k.A,{className:B.copyButtonSuccessIcon})]})})}var v=n(5048);const w={wordWrapButtonIcon:"wordWrapButtonIcon_iowe",wordWrapButtonEnabled:"wordWrapButtonEnabled_gY8A"};function T(e){let{className:t,onClick:n,isEnabled:o}=e;const s=(0,A.T)({id:"theme.CodeBlock.wordWrapToggle",message:"Toggle word wrap",description:"The title attribute for toggle word wrapping button of code block lines"});return(0,c.jsx)("button",{type:"button",onClick:n,className:(0,a.A)("clean-btn",t,o&&w.wordWrapButtonEnabled),"aria-label":s,title:s,children:(0,c.jsx)(v.A,{className:w.wordWrapButtonIcon,"aria-hidden":"true"})})}function C(e){let{children:t,className:n="",metastring:o,title:s,showLineNumbers:a,language:r}=e;const{prism:{defaultLanguage:l,magicComments:i}}=(0,m.p)(),u=function(e){return e?.toLowerCase()}(r??(0,p.Op)(n)??l),b=(0,g.A)(),f=(0,h.f)(),A=(0,p.wt)(o)||s,{lineClassNames:N,code:k}=(0,p.Li)(t,{metastring:o,language:u,magicComments:i}),B=a??(0,p._u)(o);return(0,c.jsxs)("div",{children:[A&&(0,c.jsx)("div",{className:d.codeBlockTitle,children:A}),(0,c.jsxs)("div",{children:[(0,c.jsx)(x.f4,{theme:b,code:k,language:u??"text",children:e=>{let{className:t,style:o,tokens:s,getLineProps:a,getTokenProps:r}=e;return(0,c.jsx)("pre",{tabIndex:0,ref:f.codeBlockRef,children:(0,c.jsx)("code",{children:s.map(((e,t)=>{return(0,c.jsx)(j,{line:e,getLineProps:a,getTokenProps:n.match(/lips/)?(o=r,function(){const{style:e,...t}=o(...arguments);return t}):r,classNames:N[t],showLineNumbers:B},t);var o}))})})}}),(0,c.jsxs)("div",{className:d.buttonGroup,children:[(f.isEnabled||f.isCodeScrollable)&&(0,c.jsx)(T,{className:d.codeButton,onClick:()=>f.toggle(),isEnabled:f.isEnabled}),(0,c.jsx)(y,{className:d.codeButton,code:k})]})]})]})}function _(e){let{children:t,...n}=e;const a=(0,s.A)(),r=function(e){return o.Children.toArray(e).some((e=>(0,o.isValidElement)(e)))?e:Array.isArray(e)?e.join(""):e}(t),l="string"==typeof r?C:u;return(0,c.jsx)(l,{...n,children:r},String(a))}}}]);