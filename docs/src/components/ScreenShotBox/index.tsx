import React, {
    useState,
    useRef,
    useEffect,
    CSSProperties
} from 'react';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import useScripts from '@site/src/hooks/useScripts';
import Head from '@docusaurus/Head';
import './style.css';

const example_code = `(define re #/<h1>([^>]+)<\\/h1>/)
(define str "hello")

(define obj &(:foo 10
              :bar 20))

(let loop ((i 10))
  (unless (zero? i)
    (display i)
    (newline)
    (loop (- i 1))))
`;

const WIDTH_MIN = 50;

export default function ScreenShotBox(): JSX.Element {
    const dragging = useRef<boolean>(false);
    const dialogRef = useRef<HTMLDivElement>(null);
    const boxRef = useRef<HTMLDivElement>(null);
    const resizerRef = useRef<HTMLDivElement>(null);

    const { siteConfig } = useDocusaurusContext();

    useScripts([
        'https://cdn.jsdelivr.net/combine/npm/codemirror@5.58.3/lib/codemirror.js,npm/codemirror@5.58.3/mode/javascript/javascript.js,npm/codemirror@5.58.3/addon/edit/matchbrackets.js,gh/jcubic/lips@devel/lib/js/codemirror.js',
        `${siteConfig.baseUrl}js/screenshooter.js`
    ]);

    useEffect(() => {
        function mouseMove(event: MouseEvent) {
            if (dragging.current) {
                const screenX = event.screenX;
                const rect = resizerRef.current.getBoundingClientRect();
                let diff = screenX - rect.left;
                let width = dialogRef.current.clientWidth + diff;
                if (width < WIDTH_MIN) {
                    width = WIDTH_MIN + 1;
                }
                boxRef.current.style.setProperty('--width', `${width}px`);
            }
        }
        function mouseUp() {
            dragging.current = false;
        }
        document.addEventListener('mousemove', mouseMove);
        document.addEventListener('mouseup', mouseUp);
        return () => {
            document.removeEventListener('mousemove', mouseMove);
            document.removeEventListener('mouseup', mouseUp);
        }
    }, []);


    function dragStart() {
        dragging.current = true;
    }

    return (
        <>
          <Head>
            <link href="https://cdn.jsdelivr.net/npm/codemirror@5.58.3/lib/codemirror.css" rel="stylesheet"/>
            <link href="https://cdn.jsdelivr.net/npm/codemirror@5.58.3/theme/twilight.css" rel="stylesheet"/>
            <link href="https://cdn.jsdelivr.net/npm/codemirror@5.58.3/addon/hint/show-hint.css" rel="stylesheet"/>
            <script src="https://cdn.jsdelivr.net/npm/html-to-image@1.10.4/dist/html-to-image.js"></script>
          </Head>
          <div className="box" ref={boxRef}>
            <pre className="hidden">{example_code}</pre>
            <div className="wrapper">
              <div className="resizable">
                <div className="cm-dialog" ref={dialogRef}>
                  <header>
                    <ul className="cm-icons">
                      <li></li>
                      <li></li>
                      <li></li>
                    </ul>
                  </header>
                  <div className="cm-body"></div>
                </div>
                <div className="resizer" ref={resizerRef} onMouseDown={dragStart}></div>
              </div>
            </div>
            <footer>
              <button className="download">Download Screenshot</button>
            </footer>
          </div>
        </>
    );
}
