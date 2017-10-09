module.exports = {
  npm: {
    styles: {
      'normalize.css': ['normalize.css'],
      milligram: ['dist/milligram.css']
    }
  },

  files: {
    javascripts: {
      joinTo: {
        'vendor.js': /^(?!app)/,
        'app.js': /^app/
      }
    },
    templates: {
      joinTo: 'app.js'
    },
    stylesheets: {
      joinTo: {
        'vendor.css': /^node_modules/
      }
    }
  },

  conventions: {
    assets: /^app\/static/
  },

  plugins: {
    babel: {
      presets: ['es2015']
    }
  },

  paths: {
    public: '../priv/static'
  }
}
