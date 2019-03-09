const HtmlPlugin = require('html-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const path = require('path')
const webpack = require('webpack')

module.exports = (env, { mode = 'development' }) => ({
  context: path.join(__dirname, 'src'),
  entry: [`./index.js`],
  output: {
    filename: 'bundle.js',
    path: path.join(__dirname, 'build'),
    library: 'Main'
  },
  mode: mode,
  plugins: [
    new HtmlPlugin({ template: 'index.html.ejs', inject: false })
  ],
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        uglifyOptions: {
          compress: {
            pure_funcs: [ 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9'
                        , 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9' ],
            pure_getters: true,
            keep_fargs: false,
            unsafe_comps: true,
            unsafe: true
          },
          mangle: true
        }
      })
    ]
  },
  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
        loader: 'elm-webpack-loader',
        options: { debug: 'development' === mode, optimize: 'production' === mode }
      }
    }]
  }
})
