import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import marked from 'marked';
import { Event } from "@sentry/browser";

import renderSocialCards from './src/utils';

const isProd = process.env.NODE_ENV === 'production';

prismThemes.dracula.styles.push({
  types: ['regex', 'important'],
  style: {
    color: '#fd971f'
  }
}, {
  types: ['number', 'boolean'],
  style: {
    color: '#ae81ff'
  }
});

const config: Config = {
  title: 'LIPS Scheme',
  tagline: 'Powerful Scheme based Lisp in JavaScript',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://lips.js.org',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'jcubic', // Usually your GitHub org/user name.
  projectName: 'lips', // Usually your repo name.
  deploymentBranch: 'master',

  trailingSlash: false,

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        sitemap: {
          lastmod: 'datetime',
          changefreq: 'weekly',
          filename: 'sitemap.xml',
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/jcubic/lips/tree/master/docs/',
          feedOptions: {
            type: 'rss',
            limit: 10,
            copyright: `Copyright © ${new Date().getFullYear()} Jakub T. Jankiewicz`,
            title: 'LIPS Scheme blog',
            description: 'LIPS Scheme blog RSS Feed',
            createFeedItems: async ({ blogPosts, ...params }) => {
              if (isProd) {
                 await renderSocialCards(blogPosts);
              }
              const feedItems = await params.defaultCreateFeedItems({ blogPosts, ...params });
              feedItems.forEach((feedItem,index) => {
                const blogPost = blogPosts[index]!;
                const permalink = blogPost.metadata.permalink;
                const excerpt = blogPost.content.replace(/<!--\s*truncate\s*-->[\s\S]*$/, '').trim();
                const html = (marked.parse(excerpt) as string) + `<br/><a href="${permalink}">see the rest of the article</a>`
                feedItem.content = html;
              });
              return feedItems;
            }
          }
        },
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/jcubic/lips/tree/master/docs/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/lips-social-card.png',
    navbar: {
      title: 'Scheme',
      logo: {
        alt: 'LIPS Scheme Logo',
        src: 'img/logo-black.svg',
        srcDark: 'img/logo-white.svg',
        target: '_self',
        href: '/',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Documentation',
        },
        {to: '/reference', label: 'Reference', position: 'left' },
        {to: '/blog', label: 'Blog', position: 'left'},
        {
          href: 'https://twitter.com/LIPS_scheme',
          label: 'Twitter/X',
          position: 'right'
        },
        {
          href: 'https://gitter.im/jcubic/lips',
          label: 'Chat',
          position: 'right'
        },
        {
          href: 'https://github.com/jcubic/lips',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    algolia: {
      appId: 'HSV6UC2UY5',
      apiKey: 'a7e0d09fde450addbb08f7b4af1cee8b',
      indexName: 'lips-js',
      searchPagePath: false,
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Getting Started',
              to: '/docs/intro'
            },
            {
              label: 'Introduction to Scheme',
              to: '/docs/scheme-intro/what-is-lisp'
            },
            {
              label: 'LIPS Scheme Introduction',
              to: '/docs/category/lips-introduction'
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Gitter',
              href: 'https://gitter.im/jcubic/lips',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/LIPS_scheme',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: '/blog/archive',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/jcubic/lips',
            },
          ],
        },
      ],
      copyright: `Copyright (c) 2018-${new Date().getFullYear()} <a href="https://jakub.jankiewicz.org">Jakub T. Jankiewicz</a><br/>Website content licensed with <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a> unless noted otherwise.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['scheme', 'lisp', 'bash']
    }
  } satisfies Preset.ThemeConfig,
  plugins: [
    [
      'docusaurus-plugin-sentry',
      {
        DSN: 'c6868ced9c228b7da5e50196c0ab2f14@o4508899181723648.ingest.de.sentry.io/4508899184607312',
        beforeSend(event: Event) {
          const ignoredUrls = [
            'https://umami.jcubic.pl/script.js',
            'https://cdn.jsdelivr.net/gh/jcubic/lips@devel/lib/js/bookmark.js',
          ];

          if (event.request?.url && ignoredUrls.some(url => event.request.url.includes(url))) {
            return null;
          }
          return event;
        }
      }
    ]
  ]
};

export default config;
