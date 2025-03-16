"use strict";(self.webpackChunknew_docs=self.webpackChunknew_docs||[]).push([[8130],{7735:e=>{e.exports=JSON.parse('{"archive":{"blogPosts":[{"id":"lexer","metadata":{"permalink":"/blog/lexer","editUrl":"https://github.com/jcubic/lips/tree/master/docs/blog/2025-02-20-lexer.md","source":"@site/blog/2025-02-20-lexer.md","title":"Internals: Finite-State Machine Lexer","description":"The first version of LIPS Scheme had regex based tokenizer. It was using a single regex to split the","date":"2025-02-20T00:00:00.000Z","tags":[{"inline":true,"label":"lexer","permalink":"/blog/tags/lexer"},{"inline":true,"label":"javascript","permalink":"/blog/tags/javascript"},{"inline":true,"label":"internals","permalink":"/blog/tags/internals"}],"readingTime":3.865,"hasTruncateMarker":true,"authors":[{"name":"Jakub T. Jankiewicz","title":"LIPS maintainer","url":"https://jakub.jankiewicz.org/","imageURL":"https://github.com/jcubic.png","key":"jcubic","page":null}],"frontMatter":{"slug":"lexer","title":"Internals: Finite-State Machine Lexer","authors":"jcubic","image":"/img/lexer.png","tags":["lexer","javascript","internals"]},"unlisted":false,"nextItem":{"title":"Scheme Regex literals in Emacs","permalink":"/blog/emacs-scheme-regex"}},"content":"The first version of LIPS Scheme had regex based tokenizer. It was using a single regex to split the\\ninput string into tokens. In this article, I will show the internals of the new\\n[Lexer](https://en.wikipedia.org/wiki/Lexical_analysis) in LIPS Scheme.\\n\\n\x3c!-- truncate --\x3e\\n\\nYou can still find the first version of what later become LIPS on CodePen:\\n\\n* [Simple Lisp interpreter in JavaScript](https://codepen.io/jcubic/pen/gvvzdp?editors=0011)\\n\\nWhen I started working on version 1.0 (you can read this story in article: [LIPS Scheme\\nHistory](/blog/lips-history)), the code become more and more complex, the regular expression become\\ndynamic, mostly because of [syntax extensions](/docs/lips/extension#syntax-extensions) that needed\\nto update the regular expression and the tokenizer.\\n\\nYou can see this code on GitHub on\\n[old-version branch](https://github.com/jcubic/lips/blob/old-version/src/lips.js#L201-L204)\\n\\n```javascript\\nfunction makeTokenRe() {\\n    var tokens = Object.keys(specials).map(escapeRegex).join(\'|\');\\n    return new RegExp(`(\\"(?:\\\\\\\\\\\\\\\\[\\\\\\\\S\\\\\\\\s]|[^\\"])*\\"|\\\\\\\\/(?! )[^\\\\\\\\/\\\\\\\\\\\\\\\\]*(?:\\\\\\\\\\\\\\\\[\\\\\\\\S\\\\\\\\s][^\\\\\\\\/\\\\\\\\\\\\\\\\]*)*\\\\\\\\/[gimy]*(?=\\\\\\\\s|\\\\\\\\(|\\\\\\\\)|$)|\\\\\\\\(|\\\\\\\\)|\'|\\"(?:\\\\\\\\\\\\\\\\[\\\\\\\\S\\\\\\\\s]|[^\\"])+|\\\\\\\\n|(?:\\\\\\\\\\\\\\\\[\\\\\\\\S\\\\\\\\s]|[^\\"])*\\"|;.*|(?:[-+]?(?:(?:\\\\\\\\.[0-9]+|[0-9]+\\\\\\\\.[0-9]+)(?:[eE][-+]?[0-9]+)?)|[0-9]+\\\\\\\\.)[0-9]|\\\\\\\\.{2,}|${tokens}|[^(\\\\\\\\s)]+)`, \'gim\');\\n}\\n```\\n\\nAt one point, I realized that I need to change my approach into parsing and tokenization,\\nbecause you could not add new syntax extensions in the same file that contained the code.\\nBecause the whole code was tokenized at once.\\n\\n## Finite State Machine Lexer\\n\\nThe limitation of syntax extension lead into introducing a new Lexer and a Streaming\\nParser (if you\'re interested in this topic, I will be writing an article about this in the\\nfuture).\\n\\nThe new Lexer is much simpler and easier to maintain, only had one bug recently related to\\nLexer inner working ([#433](https://github.com/jcubic/lips/issues/433)).\\n\\nThe new Lexer is a class that have rules for the state machine\\n([FSM](https://en.wikipedia.org/wiki/Finite-state_machine)), this is an example sequance\\nof rules for a string:\\n\\n```javascript\\nLexer.string = Symbol.for(\'string\');\\nLexer.string_escape = Symbol.for(\'string_escape\');\\n...\\nLexer._rules = [\\n    ...\\n    [/\\"/, null, null, Lexer.string, null],\\n    [/\\"/, null, null, null, Lexer.string],\\n    [/\\"/, null, null, Lexer.string_escape, Lexer.string],\\n    [/\\\\\\\\/, null, null, Lexer.string, Lexer.string_escape],\\n    [/./, /\\\\\\\\/, null, Lexer.string_escape, Lexer.string],\\n    ...\\n]\\n```\\n\\nThe single rule is consisted of a current character, next character, and a previous\\ncharacter (they can be single character strings or regular expressions).  If the character\\nis null, it can be any character. The last two elements of the array are the starting and\\nthe ending state (they are symbols, so they are unique values).\\n\\nThe Lexer start with null state and iterate over every rule on every character until it\\nfind a match.  If a rule enters a state and the state finish with null, it means that the\\nrule sequance was matched, and a full token is created.\\n\\nIf no rules match and the state is not null, then the characters are collected and will be\\nincluded in a final token.\\n\\nThat\'s why in above example there are no rule like this:\\n\\n```javascript\\n[/./, null, null, Lexer.string, Lexer.string]\\n```\\n\\nThis rule may be added in the future to speed up the Lexer.\\n\\n### Example\\n\\nWhen we have a string like this:\\n\\n```javascript\\n\\"foo\\\\\\"bar\\"\\n```\\n\\nIt matches the second rule because the first character is a quote, so it enters\\n`Lexer.string` state.  The first rule doesn\'t match because the initial state is null. For\\ncharacters `foo` it collects the tokens because no rule match them. When it finds slash\\n`\\\\` it changes state from `Lexer.string` to `Lexer.string_escape`, and for the next character\\nit enters again `Lexer.string`.  Then it consumes a sequence of characters `bar`, and the\\nlast quote matches the first rule. And that\'s how we have the full token.\\n\\n### Syntax Extensions and Constants\\n\\nThe static rules are located in `Lexer._rules`, but `Lexer.rules` is a getter that create the final\\nrules dynamically by adding all tokens added as syntax extensions (they are called specials in the\\ncode). This is also where other constats that starts with hash are added like: `#t`, `#f`, or\\n`#void`. They are added together with syntax extension to handle the rules matching order.\\n\\nAs an optimization, the value of dynamic rules is cached, and the cache is invalidated when a new\\nsyntax extension is added.\\n\\nThe syntax extension create a lexer rule using `Lexer.literal_rule` that creates an array of rules\\nthat match literal characters in the token, passed as first character.\\n\\nLexer is important not only when it reads input LIPS Scheme code, it\'s also used when reading from\\nI/O ports.\\n\\n## Conclusion\\n\\nAnd that\'s it, this is the whole Lexer. As you can see reading the above, it\'s very simple, easy to\\nmaintain. If you want to look how it works for yourself. You can jump into [the source\\ncode](https://github.com/jcubic/lips/tree/master/src).  And search for `\\"class Lexer\\"`,\\n`\\"Lexer._rule\\"`, `Object.defineProperty(Lexer, \'rules\'`.\\n\\nThe source code is in one file, so to navigate you need to use search. I\'ve made an attempt to split\\nthe code into modules, but failed. Because of Rollup errors about circular dependencies.\\n\\nThis was the first part of articles about [LIPS Scheme\\nInternals](https://github.com/jcubic/lips/issues/437)."},{"id":"emacs-scheme-regex","metadata":{"permalink":"/blog/emacs-scheme-regex","editUrl":"https://github.com/jcubic/lips/tree/master/docs/blog/2024-03-09-emacs-regex-literals.md","source":"@site/blog/2024-03-09-emacs-regex-literals.md","title":"Scheme Regex literals in Emacs","description":"LIPS Scheme support regular expression literals, but it\'s not the only one implementation that","date":"2024-03-09T00:00:00.000Z","tags":[{"inline":true,"label":"scheme","permalink":"/blog/tags/scheme"},{"inline":true,"label":"emacs","permalink":"/blog/tags/emacs"}],"readingTime":2.27,"hasTruncateMarker":true,"authors":[{"name":"Jakub T. Jankiewicz","title":"LIPS maintainer","url":"https://jakub.jankiewicz.org/","imageURL":"https://github.com/jcubic.png","key":"jcubic","page":null}],"frontMatter":{"slug":"emacs-scheme-regex","title":"Scheme Regex literals in Emacs","authors":"jcubic","image":"/img/emacs-scheme-regex.png","tags":["scheme","emacs"]},"unlisted":false,"prevItem":{"title":"Internals: Finite-State Machine Lexer","permalink":"/blog/lexer"},"nextItem":{"title":"LIPS Scheme History","permalink":"/blog/lips-history"}},"content":"LIPS Scheme support regular expression literals, but it\'s not the only one implementation that\\nsupport those.  Other implementation includes [Gauche](https://practical-scheme.net/gauche/) and\\n[Kawa](https://www.gnu.org/software/kawa/index.html).\\n\\nUnfortunetlly, you can\'t easily use those regular expressions in [GNU\\nEmacs](https://en.wikipedia.org/wiki/GNU_Emacs), my main editor of choice.\\n\\n\x3c!--truncate--\x3e\\n\\n## The problem\\n\\nThe main problem is when using vertical bar character inside Scheme code in Emacs. GNU Emacs thinks\\nthat the vertical bar is part of the [symbol](/docs/scheme-intro/data-types#symbols):\\n\\n```scheme\\n(let ((str \\"foo bar\\")\\n      (re #/foo|bar/)) ;; | ))\\n  (str.match re))\\n;; ==> #(\\"foo\\")\\n```\\n\\nThis blog (the same as whole website) use modified PrismJS Scheme mode that supports regular\\nexpressions. But in GNU Emacs there was a need to add `|` after a comment and close the lists that\\nwere ignored by Emacs scheme mode (because they were inside symbol).\\n\\n## The solution\\n\\nI asked a [question on emacs-devel mailing\\nlist](https://lists.gnu.org/archive/html/emacs-devel/2024-02/msg00896.html), on how to solve this\\nproblem. I didn\'t get any reply for days, then suddenly someone [reply with this emacs lisp code\\nsnippet](https://lists.gnu.org/archive/html/emacs-devel/2024-03/msg00282.html).\\n\\n```lisp\\n(defun scheme-regex-patch ()\\n  (setq-local\\n   syntax-propertize-function\\n   (lambda (start end)\\n     (goto-char start)\\n     (funcall\\n      (syntax-propertize-rules\\n       ;; For #/regexp/ syntax\\n       (\\"\\\\\\\\(#\\\\\\\\)/\\\\\\\\(\\\\\\\\\\\\\\\\/\\\\\\\\|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|.\\\\\\\\)*?\\\\\\\\(/\\\\\\\\)\\"\\n        (1 \\"|\\")\\n        (3 \\"|\\"))\\n       ;; For #; comment syntax\\n       (\\"\\\\\\\\(#\\\\\\\\);\\"\\n        (1 (prog1 \\"< cn\\"\\n             (scheme-syntax-propertize-sexp-comment\\n              (point) end)))))\\n      (point) end))))\\n\\n(add-hook \'scheme-mode-hook \'scheme-regex-patch)\\n```\\n\\nThis solution worked great, until I\'ve found that it don\'t properly handle Scheme expression\\ncomments `#;`, that are part of the solution. In the meantime on the mailing list there was discussion\\nabout this feature (probably because it\'s part of GNU Kawa) to integrate with builtin `scheme.el`.\\nSo soon you may not need a hack like this when working with regular expressions.\\n\\nThis is a proposed solution after I said that the code doesn\'t work for Scheme expression comments.\\n\\n```lisp\\n(defun scheme-regex-patch ()\\n   (setq-local\\n    syntax-propertize-function\\n    (lambda (beg end)\\n      (goto-char beg)\\n      (scheme-syntax-propertize-sexp-comment2 end)\\n      (scheme-syntax-propertize-regexp end)\\n      (funcall\\n       (syntax-propertize-rules\\n        (\\"\\\\\\\\(#\\\\\\\\);\\" (1 (prog1 \\"< cn\\"\\n                         (scheme-syntax-propertize-sexp-comment2 end))))\\n        (\\"\\\\\\\\(#\\\\\\\\)/\\" (1 (when (null (nth 8 (save-excursion\\n                                            (syntax-ppss\\n                                             (match-beginning 0)))))\\n                         (put-text-property\\n                          (match-beginning 1)\\n                          (match-end 1)\\n                          \'syntax-table (string-to-syntax \\"|\\"))\\n                         (scheme-syntax-propertize-regexp end)\\n                         nil)\\n                       )))\\n       (point) end))))\\n\\n(defun scheme-syntax-propertize-sexp-comment2 (end)\\n  (let ((state (syntax-ppss)))\\n    (when (eq 2 (nth 7 state))\\n      ;; It\'s a sexp-comment.  Tell parse-partial-sexp where it ends.\\n      (condition-case nil\\n          (progn\\n            (goto-char (+ 2 (nth 8 state)))\\n            ;; FIXME: this doesn\'t handle the case where the sexp\\n            ;; itself contains a #; comment.\\n            (forward-sexp 1)\\n            (put-text-property (1- (point)) (point)\\n                               \'syntax-table (string-to-syntax \\"> cn\\")))\\n        (scan-error (goto-char end))))))\\n\\n(defun scheme-syntax-propertize-regexp (end)\\n  (let* ((state (syntax-ppss))\\n         (within-str (nth 3 state))\\n         (start-delim-pos (nth 8 state)))\\n    (when (and within-str\\n               (char-equal ?# (char-after start-delim-pos)))\\n      (while\\n          (and\\n           (re-search-forward \\"/\\" end \'move)\\n           (eq -1\\n               (% (save-excursion\\n                    (backward-char)\\n                    (skip-chars-backward \\"\\\\\\\\\\\\\\\\\\")) 2))))\\n      (when (< (point) end)\\n        (progn\\n          (put-text-property\\n           (match-beginning 0)\\n           (match-end 0)\\n           \'syntax-table (string-to-syntax \\"|\\")))))))\\n\\n(add-hook \'scheme-mode-hook \'scheme-regex-patch)\\n```\\n\\nYou can read the whole discussion on [emacs-devel mailing list archive](https://lists.gnu.org/archive/html/emacs-devel/2024-03/msg00590.html)."},{"id":"lips-history","metadata":{"permalink":"/blog/lips-history","editUrl":"https://github.com/jcubic/lips/tree/master/docs/blog/2024-03-03-lips-history.md","source":"@site/blog/2024-03-03-lips-history.md","title":"LIPS Scheme History","description":"This is the first article on LIPS blog. In this article I will write about the history of LIPS","date":"2024-03-03T00:00:00.000Z","tags":[{"inline":true,"label":"lips","permalink":"/blog/tags/lips"},{"inline":true,"label":"scheme","permalink":"/blog/tags/scheme"},{"inline":true,"label":"history","permalink":"/blog/tags/history"}],"readingTime":1.825,"hasTruncateMarker":true,"authors":[{"name":"Jakub T. Jankiewicz","title":"LIPS maintainer","url":"https://jakub.jankiewicz.org/","imageURL":"https://github.com/jcubic.png","key":"jcubic","page":null}],"frontMatter":{"slug":"lips-history","title":"LIPS Scheme History","authors":"jcubic","image":"/img/lips-history.png","tags":["lips","scheme","history"]},"unlisted":false,"prevItem":{"title":"Scheme Regex literals in Emacs","permalink":"/blog/emacs-scheme-regex"}},"content":"This is the first article on LIPS blog. In this article I will write about the history of LIPS\\nScheme interpreter.\\n\\n\x3c!--truncate--\x3e\\n\\n## What is Scheme?\\n\\nScheme is a dialect of the Lisp. The second oldest programming language still in use (after\\nFortran).  Lisp and Scheme have specific syntax with prefix notation and where everything is a list\\n(at least historically).  It\'s also [Homoiconic](https://en.wikipedia.org/wiki/Homoiconicity), which\\nmeans that code and data have the same represantion. This allows to write programs that modify the\\ncode like it was data.\\n\\n## What is LIPS?\\n\\nLIPS name is a recursive ancronym which stands for **\\"LIPS Is Pretty Simple\\"**. LIPS Scheme is\\nimplementation of Scheme programming language in JavaScript. It adds a lot of stuff on top of Scheme\\nto make it more powerful and easier to interact with JavaScript.\\n\\n## History of LIPS\\n\\nIt all started in February 2018 when I\'ve written the first version of a Lisp interpreter. You can\\nstill see the code on [CodePen](https://codepen.io/jcubic/pen/gvvzdp). Then I moved the [development\\nto GitHub](https://github.com/jcubic/lips) and named the project LIPS.  The first release (version\\n0.2.0) is marked as Mar 2018.\\n\\nThe reason why I created another lisp in JavaScript was because I wanted to have an Emacs in browser\\nthat would have a real lisp inside. That\'s why LIPS had dynamic scope as an option. GNU Emacs use\\nElisp that for a long time had dynamic scope. So I was planing to emulate that.\\n\\nAt the beginning it was Lisp based on Scheme, but at one point after version\\n[0.20.1 dated as Jul 1, 2020](https://github.com/jcubic/lips/releases/tag/0.20.1), I\'ve started\\nadding features on devel branch and decided that I want a full Scheme implementation. But it turns out\\nthat there were way too many breaking changes to release the next version. So I decided that I will\\nrelease it as 1.0-beta. Since then, LIPS keeps introducing new Beta versions. You can see the\\n[latest release on GitHub](https://github.com/jcubic/lips/releases).\\n\\n## Future of LIPS\\n\\nFor the future plans I want in final version 1.0 are implementation of continutations and Tail Calls\\n(<abbr title=\\"Tail Call Optimization\\">TCO</abbr>) and to be compatible (more or less) with\\n[R<sup>7</sup>RS specification](https://standards.scheme.org/). To see the progress, you can check\\n[1.0 Milestone on GitHub](https://github.com/jcubic/lips/issues?q=is%3Aopen+is%3Aissue+milestone%3A1.0)."}]}}')}}]);