const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
  title: 'Atomontage Docs',
  tagline: 'Atomontage Tools Documentation',
  url: 'https://atomontagedocs.netlify.app/',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  organizationName: 'mkster', // Usually your GitHub org/user name.
  projectName: 'atomontage-docs', // Usually your repo name.
  themeConfig: {
    colorMode: {
      defaultMode: 'dark',
    },
    navbar: {
      title: 'Atomontage Documentation',
      logo: {
        alt: 'Atomontage Logo',
        src: 'img/logo_large.png',
      },
      items: [
        /*
        {
          type: 'doc',
          docId: 'intro',
          position: 'left',
          label: 'Docs',
        },
        //{to: '/blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/facebook/docusaurus',
          label: 'GitHub',
          position: 'right',
        },
        */
      ],
    },
    footer: {
      style: 'dark',
      links: [
        /*
        {
          title: 'Docs',
          items: [
            {
              label: 'Tutorial',
              to: '/docs/intro',
            },
          ],
        },
        */
        {
          title: 'Community',
          items: [
            {
              label: 'Atomontage',
              href: 'https://www.atomontage.com/',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/atomontage_com',
            },
            {
              label: 'YouTube',
              href: 'https://www.youtube.com/channel/UClzSvcwdGx9v66YRza5u_Mg',
            },
          ],
        },
        {
          title: 'More',
          items: [
            /*
            {
              label: 'Blog',
              to: '/blog',
            },
            */
            {
              label: 'GitHub',
              href: 'https://github.com/mkster/atomontage-docs/tree/master/',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Atomontage Inc.`,
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
      additionalLanguages: ['lua'],
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/mkster/atomontage-docs/tree/master/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://github.com/mkster/atomontage-docs/tree/master/blog/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
