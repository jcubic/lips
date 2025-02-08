#!/usr/bin/env node
import fs from 'fs/promises';
import { tco_eval, exec, parse, evaluate, env } from './src/lips.js';

//internal LIPS code debugger
//env.__parent__.set('DEBUG', 'eval');

/*
  This is the logic of calls in js-scheme

  doEval(obj)
    state = new State(obj, TopEnv, topCC);
    while (true) {
      if (state.eval)
        cont
      catch
        return e.obj

  evalPair(state)
    if (car == theLambda)
      state.obj = Lambda
      state.ready = true;
    else
      state.obj = car;
      state.cc = Continuation(cdr, continuePair);
      state.ready = false

  ContinuePair(state)
     args = new Pair(this[i]);
     state.obj = callF(this[0], args, state);

  Apply(f, args)
    while (true) {
      if (f instanceof Lambda)
        state = new Sate
        state.obj = CallF(f, args, state);
        try
          while (true)
            if (state.eval)
               cont
        catch
          return ex.obj
      if (f instanceof Continuation)
        throw new State(args,null,f);

  CallF(f, args, state)
    while (true) {
      lambda:
        sate.env from args
        state.ready = false;
        return f.body;
      continuation:
        state.ready = true;
        state.cc = f.clone
        return args.car

*/

const code = `

`;

Promise.all(['./lib/bootstrap.scm', './asserts.scm'].map(fname => {
    return fs.readFile(fname, 'utf8');
})).then(([lib, asserts]) => {
    // lib is ignored for now
    return exec(asserts, { env });
    // this is old testing code that work like REPL
    /*
    const repr = env.get('repr');
    return parse(code).then(async result => {
        for (let code of result) {
            let result = await tco_eval(code, {
                env,
                error: (e) => {
                    throw e;
                }
            });
            if (result !== undefined) {
                console.log('==> ' + repr(result));
            }
        }
    });
    */
}).catch(e => {
    const stack = e.__code__?.join('\n');
    if (stack) {
        console.log(stack);
    } else {
        console.log('[EMPTY STACK]');
    }
    console.log(e);
}).then(() => {
    console.log('DONE');
    const tests = env.get('tests', { throwError: false })?.valueOf();
    const passed = env.get('passed', { throwError: false })?.valueOf();
    console.log(`tests passed: ${passed}/${tests}`);
});
