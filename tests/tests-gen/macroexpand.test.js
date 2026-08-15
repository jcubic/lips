import 'ava';
import { exec } from '../../src/lips.js';
import fs from 'fs/promises';

const code = await fs.readFile(new URL('../../tests/macroexpand.scm', import.meta.url), 'utf8');
await exec(`
  (let-env lips.env.__parent__
    (load "@lips/dist/std.xcb")
    (load "@lips/lib/srfi/258.scm")
    (load "@lips/tests/helpers/helpers.scm"))
  (define test (require "ava"))`);
await exec(code);
