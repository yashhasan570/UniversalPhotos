// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const prism = require('prism-react-renderer');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'UniversalPhotos',
  tagline: 'Self-hosted photo and video management solution',
  url: 'https://docs.',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'img/favicon.png',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'universal_photos-app', // Usually your GitHub org/user name.
  projectName: 'universal_photos', // Usually your repo name.
  deploymentBranch: 'main',
  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  // Mermaid diagrams
  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },
  themes: ['@docusaurus/theme-mermaid'],

  plugins: [
    async function myPlugin(context, options) {
      return {
        name: 'docusaurus-tailwindcss',
        configurePostCss(postcssOptions) {
          // Appends TailwindCSS and AutoPrefixer.
          postcssOptions.plugins.push(require('tailwindcss'));
          postcssOptions.plugins.push(require('autoprefixer'));
          return postcssOptions;
        },
      };
    },
    require.resolve('docusaurus-lunr-search'),
  ],
  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
          routeBasePath: '/',

          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/yashhasan570/UniversalPhotos/tree/main/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      docs: {
        sidebar: {
          autoCollapseCategories: false,
        },
      },
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 4,
      },
      navbar: {
        logo: {
          alt: 'UniversalPhotos Logo',
          src: 'img/universal_photos-logo-inline-light.png',
          srcDark: 'img/universal_photos-logo-inline-dark.png',
          className: 'rounded-none',
        },
        items: [
          {
            type: 'custom-versionSwitcher',
            position: 'right',
          },
          {
            href: 'https:///',
            position: 'right',
            label: 'Home',
          },
          {
            href: 'https://github.com/yashhasan570/UniversalPhotos',
            label: 'GitHub',
            position: 'right',
          },
          {
            type: 'html',
            position: 'right',
            value:
              '<a href="https://buy." target="_blank" class="no-underline hover:no-underline"><button class="buy-button bg-universal_photos-primary dark:bg-universal_photos-dark-primary text-white dark:text-black rounded-xl">Buy UniversalPhotos</button></a>',
          },
        ],
      },
      footer: {
        style: 'light',
        links: [
          {
            title: 'Download',
            items: [
              {
                label: 'Android',
                href: 'https://get./android',
              },
              {
                label: 'iOS',
                href: 'https://get./ios',
              },
              {
                label: 'Server',
                href: 'https:///download',
              },
            ],
          },
          {
            title: 'Company',
            items: [
              {
                label: 'FUTO',
                href: 'https://futo.tech/',
              },
              {
                label: 'Purchase',
                href: 'https://buy./',
              },
              {
                label: 'Merch',
                href: 'https://universal_photos.store/',
              },
            ],
          },
          {
            title: 'Sites',
            items: [
              {
                label: 'Home',
                href: 'https://',
              },
              {
                label: 'My UniversalPhotos',
                href: 'https://my./',
              },
              {
                label: 'Awesome UniversalPhotos',
                href: 'https://awesome./',
              },
              {
                label: 'UniversalPhotos API',
                href: 'https://api./',
              },
              {
                label: 'UniversalPhotos Data',
                href: 'https://data./',
              },
              {
                label: 'UniversalPhotos Datasets',
                href: 'https://datasets./',
              },
            ],
          },
          {
            title: 'Miscellaneous',
            items: [
              {
                label: 'Roadmap',
                href: 'https:///roadmap',
              },
              {
                label: 'Cursed Knowledge',
                href: 'https:///cursed-knowledge',
              },
              {
                label: 'Privacy Policy',
                href: 'https:///privacy-policy',
              },
            ],
          },
          {
            title: 'Social',
            items: [
              {
                label: 'GitHub',
                href: 'https://github.com/yashhasan570/UniversalPhotos',
              },
              {
                label: 'YouTube',
                href: 'https://www.youtube.com/@universal_photos-app',
              },
              {
                label: 'Discord',
                href: 'https://discord.',
              },
              {
                label: 'Reddit',
                href: 'https://www.reddit.com/r/universal_photos/',
              },
            ],
          },
        ],
        copyright: `UniversalPhotos is available as open source under the terms of the GNU AGPL v3 License.`,
      },
      prism: {
        theme: prism.themes.github,
        darkTheme: prism.themes.dracula,
        additionalLanguages: ['sql', 'diff', 'bash', 'powershell', 'nginx'],
      },
      image: 'img/feature-panel.png',
    }),
};

module.exports = config;
