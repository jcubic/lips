import React from 'react';
import clsx from 'clsx';
import { useLocation } from '@docusaurus/router';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

import MoreIcon from '@site/src/components/MoreIcon';
import './style.css';
const NotByAI = require('@site/static/img/Written-By-Human-Not-By-AI-Badge-black.svg').default

export default function FooterLayout({style, links, logo, copyright}) {
  const { pathname: currentPath } = useLocation();
  const { siteConfig: { baseUrl } } = useDocusaurusContext();

  return (
    <footer
      className={clsx('footer', {
        'footer--dark': style === 'dark',
      })}>
      <div className="container container-fluid">
        {links}
        {(logo || copyright) && (
          <div className="footer__bottom text--center">
            {logo && <div className="margin-bottom--sm">{logo}</div>}
            {copyright}
            <a href="https://notbyai.fyi" aria-label="Created not by AI"><NotByAI /></a>
          </div>
        )}
      </div>
      {baseUrl === currentPath && <MoreIcon />}
      <script defer src="https://cloud.umami.is/script.js" data-website-id="422bfe77-bcfe-4cf8-a923-d496fba1bcc3" />
    </footer>
  );
}
