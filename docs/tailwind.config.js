// tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  corePlugins: {
    preflight: false, // disable Tailwind's reset
  },
  content: ['./docusaurus.config.js', './src/**/*.{js,jsx,ts,tsx}', './{docs,blog}/**/*.{md,mdx}'], // my markdown stuff is in ../docs, not /src
  darkMode: ['class', '[data-theme="dark"]'], // hooks into docusaurus' dark mode settings
  theme: {
    extend: {
      colors: {
        // Light Theme
        'universal_photos-primary': '#4250af',

        // Dark Theme
        'universal_photos-dark-primary': '#adcbfa',
      },
    },
  },
  plugins: [],
};
