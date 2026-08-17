#!/usr/bin/env node
/* Browser smoke test.
 *
 * Loads tests/test.html in a headless Chromium (puppeteer) and checks that the
 * `<script type="text/x-scheme">` block ran - i.e. LIPS bootstrapped from the
 * script tag (dist/lips.js + dist/std.xcb) and evaluated Scheme in the page.
 * The page's script does (console.log "hello, world!"); we assert that text
 * reaches the browser console.
 *
 * A tiny static file server is used because the page uses fetch() (for the
 * std.xcb bootstrap), which the browser blocks on file:// URLs.
 */
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import puppeteer from 'puppeteer';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const PAGE = '/tests/test.html';
const EXPECTED = 'hello, world!';
const TIMEOUT = 30000;

const MIME = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.mjs': 'text/javascript',
    '.cjs': 'text/javascript',
    '.esm': 'text/javascript',
    '.json': 'application/json',
    '.scm': 'text/plain',
    '.xcb': 'application/octet-stream'
};

function serve() {
    const server = http.createServer((req, res) => {
        const url = decodeURIComponent(req.url.split('?')[0]);
        const file = path.join(ROOT, path.normalize(url));
        if (!file.startsWith(ROOT)) {
            res.writeHead(403).end('Forbidden');
            return;
        }
        fs.readFile(file, (err, data) => {
            if (err) {
                res.writeHead(404).end('Not found');
                return;
            }
            res.writeHead(200, {
                'Content-Type': MIME[path.extname(file)] || 'application/octet-stream'
            });
            res.end(data);
        });
    });
    return new Promise(resolve => {
        server.listen(0, '127.0.0.1', () => resolve(server));
    });
}

function fail(message) {
    console.error(`browser smoke: FAILED - ${message}`);
    process.exit(1);
}

// Allow overriding the browser binary (PUPPETEER_EXECUTABLE_PATH) - the
// puppeteer-bundled Chromium may not run on every distro; a system
// google-chrome/chromium usually does.
function find_chrome() {
    if (process.env.PUPPETEER_EXECUTABLE_PATH) {
        return process.env.PUPPETEER_EXECUTABLE_PATH;
    }
    const candidates = [
        '/usr/bin/google-chrome-stable',
        '/usr/bin/google-chrome',
        '/usr/bin/chromium-browser',
        '/usr/bin/chromium'
    ];
    return candidates.find(p => fs.existsSync(p));
}

const server = await serve();
const port = server.address().port;
const browser = await puppeteer.launch({
    headless: 'new',
    executablePath: find_chrome(),
    args: ['--no-sandbox', '--disable-setuid-sandbox']
});

let timer;
try {
    const page = await browser.newPage();
    const logs = [];
    page.on('console', msg => logs.push(msg.text()));
    page.on('pageerror', err => logs.push(`PAGEERROR: ${err.message}`));

    const seen = new Promise((resolve, reject) => {
        page.on('console', msg => {
            if (msg.text().includes(EXPECTED)) {
                resolve();
            }
        });
        timer = setTimeout(() => {
            reject(new Error(`timed out after ${TIMEOUT}ms waiting for ` +
                             `"${EXPECTED}"`));
        }, TIMEOUT);
    });

    await page.goto(`http://127.0.0.1:${port}${PAGE}`, {
        waitUntil: 'networkidle0',
        timeout: TIMEOUT
    });
    await seen;

    // no bootstrap/eval error should have reached the console
    const errors = logs.filter(l => /Unbound variable|PAGEERROR|Uncaught/i.test(l));
    if (errors.length) {
        fail(`console reported errors:\n  ${errors.join('\n  ')}`);
    }
    console.log('browser smoke: all checks passed');
} catch (e) {
    fail(e.message);
} finally {
    clearTimeout(timer);
    await browser.close();
    server.close();
}
