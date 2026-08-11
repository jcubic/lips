import highlight from 'prism-cli';
import Prism from 'prismjs';
import 'prismjs/components/prism-scheme.min.js';
import './prism.js';
import { Pair, LString, Formatter, type } from '../../src/lips.js';

export default function pprint(input) {
    if (input instanceof Pair) {
        input = new Formatter(input.toString(true)).break().format();
    }
    if (input instanceof LString) {
        input = input.valueOf();
    }
    if (typeof input !== 'string') {
        throw new Error(`invalid argument, expecting string or pair, got ${type(input)}!`);
    }
    return highlight(input, 'scheme', {
        grammar: Prism.languages.scheme,
        newlines: true
    });
}
