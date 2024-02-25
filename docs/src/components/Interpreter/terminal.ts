export default function initTerminal() {
  const $ = globalThis.$;
  $.terminal.syntax('scheme');
  $('.term').empty();
  const term = globalThis.terminal({
    selector: '.term',
    dynamic: false,
    name: 'demo',
    lips: globalThis.lips
  });
  term.tooltips($('.example'), ($node: any) => $node.text(), function($node: any) {
    const offset = $node.offset();
    const top = offset.top;
    const left = offset.left;
    const right = offset.left + $node.width();
    return { top, right, left };
  });

  const intro = `LIPS version ${globalThis.lips.version}
Copyright (c) 2018-${new Date().getFullYear()} [[!;;;;https://jcubic.pl/me]Jakub T. Jankiewicz]

Type (env) to see environment with functions macros and variables
You can also use (help obj)to display help for specic function or macro.
Use (dir name) to get list of JavaScript properties and (apropos name)
to display list of matched names in environment.`

  term.echo(intro.replace(/(\((?:env|dir|help|apropos)[^)]*\))/g, function(code) {
    return $.terminal.prism('scheme', code, { echo: true });
  }), {
    formatters: false
  });
};