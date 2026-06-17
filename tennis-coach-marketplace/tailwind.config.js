/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        tennis: {
          green: '#16a34a',
          'green-dark': '#15803d',
          'green-light': '#dcfce7',
          yellow: '#ca8a04',
          'yellow-light': '#fef9c3',
        },
      },
    },
  },
  plugins: [],
};
