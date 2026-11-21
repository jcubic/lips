/*
 * Generates one AVA test file per Scheme test file so the suite runs across
 * multiple processes (AVA only parallelises across files, not within one).
 *
 * Each generated `tests/tests-gen/<name>.test.js` bootstraps LIPS and execs a
 * single `tests/<name>.scm` at the module top level - exactly like the original
 * tests/test.js - so the `(test ...)` calls inside the Scheme file register real
 * AVA tests in that file's own worker process.
 *
 * This file is part of LIPS - Scheme based Powerful Lisp in JavaScript
 * Copyright (c) 2018-2026 Jakub T. Jankiewicz <https://jcubic.pl/me>
 * Released under the MIT license
 */
import fs from 'fs/promises';
import { basename } from 'path';

const TESTS_DIR = './tests';
const OUT_DIR = './tests/tests-gen';

// same selection as the original tests/test.js: top-level *.scm, skipping
// underscore-prefixed and Emacs lock files
const files = (await fs.readdir(TESTS_DIR))
    .filter(file => file.endsWith('.scm') && !/^\.#|^_/.test(file));

// recreate the output directory from scratch so removed .scm files don't leave
// stale runners behind
await fs.rm(OUT_DIR, { recursive: true, force: true });
await fs.mkdir(OUT_DIR, { recursive: true });

function runner(scm) {
    // paths are relative to the generated file in tests/tests-gen/, hence ../../
    return `import 'ava';
import { exec } from '../../src/lips.js';
import fs from 'fs/promises';

const code = await fs.readFile(new URL('../../tests/${scm}', import.meta.url), 'utf8');
await exec(\`
  (letenv lips.env.__parent__
    (load "@lips/dist/std.xcb")
    (load "@lips/lib/srfi/258.scm")
    (load "@lips/tests/helpers/helpers.scm"))
  (define test (require "ava"))\`);
await exec(code);
`;
}

await Promise.all(files.map(scm => {
    const name = basename(scm, '.scm');
    return fs.writeFile(`${OUT_DIR}/${name}.test.js`, runner(scm));
}));

console.log(`generated ${files.length} test runners in ${OUT_DIR}`);
