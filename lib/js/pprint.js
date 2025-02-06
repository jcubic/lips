import highlight from 'prism-cli';
import Prism from 'prismjs';
import 'prismjs/components/prism-scheme.min.js';
import '../lib/js/prism.js';
import lips from './lips.js';

export default function pprint(input) {
    if (input instanceof lips.Pair) {
        input = new lips.Formatter(input.toString(true)).break().format();
    }
    if (input instanceof lips.LString) {
        input = input.valueOf();
    }
    if (typeof input !== 'string') {
        throw new Error(`invalid argument, expecting string or pair, got ${lips.type(input)}!`);
    }
    return highlight(input, 'scheme', {
        grammar: Prism.languages.scheme,
        newlines: true
    });
}
