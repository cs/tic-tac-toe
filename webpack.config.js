const CopyPlugin = require('copy-webpack-plugin');
const HtmlPlugin = require('html-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const path = require('path')
const webpack = require('webpack')

const flags = {};

module.exports = (env, { mode = 'development', product = 'default' }) => ({
  context: path.join(__dirname, 'src'),
  entry: [`./index.${product}.js`],
  output: {
    filename: 'bundle.js',
    path: path.join(__dirname, `build/${product}`),
    library: 'Main'
  },
  mode: mode,
  plugins: [
    new CopyPlugin([{ from: 'assets' }]),
    new HtmlPlugin({
      template: `index.${product}.html.ejs`,
      inject: false,
      base: `/${process.env.CIRCLE_SHA1 ? process.env.CIRCLE_SHA1 + '/' : ''}`,
      flags
    })
  ],
  module: {
    rules: [{
      test: /\.elm$/,
      use: {
        loader: 'elm-webpack-loader',
        options: { debug: 'development' === mode, optimize: 'production' === mode }
      }
    }]
  },
  devServer: {
    port: 3000,
    disableHostCheck: true,
    historyApiFallback: true,
    overlay: { warnings: true, errors: true }
  },
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        uglifyOptions: {
          compress: {
            pure_funcs: [ 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9'
                        , 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9' ],
            pure_getters: true,
            unsafe_comps: true,
            unsafe: true
          },
          mangle: true
        }
      })
    ]
  }
})
