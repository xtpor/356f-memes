module.exports = {
  npm: {
    styles: {
      'normalize.css': ['normalize.css'],
      milligram: ['dist/milligram.css'],
      cropperjs: ['dist/cropper.css'],
      'font-awesome': ['css/font-awesome.css'],
    }
  },

  files: {
    javascripts: {
      joinTo: {
        'js/vendor.js': /^(?!app)/,
        'js/app.js': /^app/
      }
    },
    templates: {
      joinTo: 'js/app.js'
    },
    stylesheets: {
      joinTo: {
        'css/vendor.css': /^node_modules/
      }
    }
  },

  notifications: false,

  conventions: {
    assets: /^app\/static/
  },

  plugins: {
    babel: {
      presets: ['es2015']
    },
    copycat: {
      fonts: ["node_modules/font-awesome/fonts"],
      verbose: false
    }
  },

  paths: {
    public: '../priv/static'
  }
}
