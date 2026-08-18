---
slug: evaluate-scheme-in-emacs
title: "Problem with Evaluating Scheme Expressions in Emacs"
authors: jcubic
image: /img/emacs-expression.png
tags: [scheme, emacs]
---

I was checking the new beta release of LIPS Scheme in GNU Emacs. I was searching for a way to
execute an expression in Scheme mode when using the cmuscheme Scheme REPL in the other window. It
turned out that it's standard `C-x C-e` ([same as for
elisp](https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Eval.html)). The problem is
that it displays the prompt multiple times when you execute code that doesn't produce any output.

<!-- truncate -->

If you evaluate the code:

```scheme
(define foo 10)
```

You will get:

```
lips> lips>
```

Each time you evaluate an expression that doesn't produce the output, Emacs appends another prompt in the same line.


I asked Claude Code to create advice to fix the issue. This is who he came with:

```lisp
(defun my-scheme-send-newline (&rest _)
  "Terminate the current line in the inferior Scheme buffer before a
buffer-send, so the next prompt lands on its own line instead of being
appended right after the current prompt (e.g. `lips> lips>')."
  (let ((proc (ignore-errors (scheme-proc))))
    (when (and proc (process-live-p proc))
      (with-current-buffer (process-buffer proc)
        (save-excursion
          (goto-char (process-mark proc))
          ;; don't add a blank line if already at bol
          (unless (bolp)
            (let ((inhibit-read-only t))
              ; ; moves process-mark past the newline
              (insert-before-markers "\n"))))))))

(advice-add 'scheme-send-region :before #'my-scheme-send-newline)
```

Adding this solves the issue. The problem is that this is how it works for every Scheme interpreter that I've tried.

I've tested Guile 3.0, Gambit, and Chicken.

I've asked about this on the Emacs-devel mailing list. We will see what they will say.

Here is the thread: https://lists.gnu.org/archive/html/emacs-devel/2026-08/msg00603.html
