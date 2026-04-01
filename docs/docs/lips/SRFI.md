---
sidebar_position: 8
description: List of supported SRFI
---

# SRFI

## Builtin SRFI

This is a list of builin SRFI that don't require any action from user:

| description | spec |
| :--- | ---: |
| Feature-based conditional expansion construct | [SRFI-0](https://srfi.schemers.org/srfi-0/) |
| Homogeneous numeric vector datatypes | [SRFI-4](https://srfi.schemers.org/srfi-4/) |
| Basic String Ports | [SRFI-6](https://srfi.schemers.org/srfi-6/) |
| Running Scheme Scripts on Unix | [SRFI-22](https://srfi.schemers.org/srfi-22/) |
| Error reporting mechanism | [SRFI-23](https://srfi.schemers.org/srfi-23/) |
| Basic Format Strings | [SRFI-28](https://srfi.schemers.org/srfi-28/) |
| Basic Syntax-rules Extensions | [SRFI-46](https://srfi.schemers.org/srfi-46/) |
| An interface to access environment variables | [SRFI-98](https://srfi.schemers.org/srfi-98/) |
| Syntax parameters | [SRFI-139](https://srfi.schemers.org/srfi-139/) |
| Custom macro transformers | [SRFI-147](https://srfi.schemers.org/srfi-147/) |
| Version flag | [SRFI-176](https://srfi.schemers.org/srfi-176/) |
| Command line | [SRFI-193](https://srfi.schemers.org/srfi-193/) |

## Included SRFI

Those SRFI are included as files that can be loaded into LIPS Scheme system:

| description | spec | source |
| :--- | :---: | :---: |
| List Library | [SRFI-1](https://srfi.schemers.org/srfi-1/) | [1.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/1.scm) |
| `AND-LET*`: an AND with local bindings, a guarded `LET*` special form | [SRFI-2](https://srfi.schemers.org/srfi-2/) | [2.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/2.scm) |
| receive: Binding to multiple values | [SRFI-8](https://srfi.schemers.org/srfi-8/) | [8.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/8.scm) |
| `#,` external form | [SRFI-10](https://srfi.schemers.org/srfi-10/) | [10.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/10.scm) |
| Notation for Specializing Parameters without Currying | [SRFI-26](https://srfi.schemers.org/srfi-26/) | [26.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/26.scm) |
| A more general `cond` clause | [SRFI-61](https://srfi.schemers.org/srfi-61/) | [61.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/61.scm) |
| Basic hash tables | [SRFI-69](https://srfi.schemers.org/srfi-69/) | [69.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/69.scm) |
| Boxes | [SRFI-111](https://srfi.schemers.org/srfi-111/) | [111.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/111.scm) |
| Syntactic combiners for binary predicates | [SRFI-156](https://srfi.schemers.org/srfi-156/) | [156.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/156.scm) |
| Multiple-value boxes | [SRFI-195](https://srfi.schemers.org/srfi-195) | [195.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/195.scm) |
| Procedures and Syntax for Multiple Values | [SRFI-210](https://srfi.schemers.org/srfi-210/) | [210.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/210.scm) |
| Evaluating expressions in an unspecified order | [SRFI-236](https://srfi.schemers.org/srfi-236) | [236.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/236.scm) |
| Applicative syntax | [SRFI-239](https://srfi.schemers.org/srfi-239/) | [239.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/239.scm) |
| Gensym | [SRFI-258](https://srfi.schemers.org/srfi-258/) | [258.scm](https://github.com/jcubic/lips/blob/master/lib/srfi/258.scm) |

On the Web you can use this code to load above SRFI:

```scheme
(load "https://cdn.jsdelivr.net/npm/lips@beta/lib/srfi/<NUMBER>.scm")
```

In NodeJS you can use this code:

```scheme
(load "<LIPS PATH>/lib/srfi/<number>.scm")
```

## Future plans

On devel branch there is a way to load those SRFI with `@lips` marker instead of full path.
The final version LIPS 1.0 will most likely include some mechanism to load SRFI as R7RS libraries.


