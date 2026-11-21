/*
 * Bootstrap tests written in Scheme using AVA testing framework
 *
 * This file is part of the LIPS - Scheme based Powerful lips in JavaScript
 *
 * Copyright (c) 2018-2020 Jakub T. Jankiewicz <https://jcubic.pl/me>
 * Released under the MIT license
 */

// without this tests stop before running LIPS files
import ava from 'ava';
import lily from '@jcubic/lily';
import fs from 'fs/promises';
import { glob } from 'glob';
import { basename } from 'path';

import { exec } from '../src/lips.js';

const readDir = fs.readdir;
const readFile = fs.readFile;

async function get_files() {
    const options = lily(process.argv.slice(2));
    if (options.f) {
        return [...await glob(options.f)];
    }
    var files = await fs.readdir('./tests');
    return files.filter(function(file) {
        return file.match(/.scm$/) && !file.match(/^\.#|^_/);
    }).map(name => `./tests/${name}`);
}

get_files().then(filenames => {
    return Promise.all(filenames.map(function(file) {
        return fs.readFile(file, 'utf8');
    })).then(async function (files) {
        await exec(`
          (letenv lips.env.__parent__
            (load "@lips/dist/std.xcb")
            (load "@lips/lib/srfi/258.scm")
            (load "@lips/tests/helpers/helpers.scm"))
          (define test (require "ava"))
        `);
        return exec(files.join('\n\n'));
    });
}).catch(e => {
    console.error(e.message);
    console.error(e.stack);
    if (e.__code__) {
        console.log(e.__code__.join('\n'));
    }
});
