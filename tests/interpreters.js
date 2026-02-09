/*
 * JavaScript API test
 *
 * This file is part of the LIPS - Scheme based Powerful lips in JavaScript
 *
 * Copyright (c) 2018-2020 Jakub T. Jankiewicz <https://jcubic.pl/me>
 * Released under the MIT license
 */
import test from 'ava';
import { Interpreter, OutputPort, LString } from '../src/lips.js';

const env = {
    stdout: OutputPort(function(x) {
        if (typeof x !== 'string') {
            x = this.get('repr')(x);
        }
        this.get('__buffer__').push(x);
    }),
    sleep(time) {
        return new Promise(resolve => {
            setTimeout(resolve, time.valueOf());
        });
    }
};

test('javascript: async buffer access', async function(t) {
    const interpreter_1 = Interpreter('repl', {
        __buffer__: [],
        meta: true,
        ...env
    });

    const interpreter_2 = Interpreter('repl', {
        __buffer__: [],
        meta: false,
        ...env
    });

    await Promise.all([
        interpreter_1.exec('(begin (sleep 100) (display "hello") (newline))'),
        interpreter_2.exec('(begin (sleep 50) (display "world") (newline))')
    ]);

    t.deepEqual(interpreter_1.__env__.get('__buffer__'), ['hello', '\n']);
    t.deepEqual(interpreter_2.__env__.get('__buffer__'), ['world', '\n']);
});
