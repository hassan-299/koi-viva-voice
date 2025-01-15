const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  plugins: {
    'postcss-import': {},
    'tailwindcss/nesting': 'postcss-nesting',
    autoprefixer: {},
    cssnano: { preset: 'default' },
    tailwindcss: {
      content: [
        './app/views/**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/assets/stylesheets/**/*.css',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}'
      ],
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter var', ...defaultTheme.fontFamily.sans]
          }
        }
      },
      plugins: [
        require('@tailwindcss/aspect-ratio'),
        require('@tailwindcss/typography')
      ]
    }
  }
}
