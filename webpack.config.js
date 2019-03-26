const CopyPlugin = require('copy-webpack-plugin');
const HtmlPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin")
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const path = require('path')
const webpack = require('webpack')

const commonFlags = {
}

const developmentFlags = Object.assign({}, commonFlags, {
})

const productionFlags = Object.assign({}, commonFlags, {
})

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
      template: `index.html.ejs`,
      inject: false,
      base: `/${process.env.CIRCLE_SHA1 ? process.env.CIRCLE_SHA1 + '/' : ''}`,
      flags: mode === 'production' ? productionFlags : developmentFlags
    }),
    new MiniCssExtractPlugin({ filename: "bundle.css" })
  ],
  module: {
    rules: [{
      test: /\.elm$/,
      use: {
        loader: 'elm-webpack-loader',
        options: { debug: 'development' === mode, optimize: 'production' === mode }
      }
    }, {
      test: /\.css$/,
      use: [MiniCssExtractPlugin.loader, 'css-loader']
    }]
  },
  devServer: {
    port: 3000,
    allowedHosts: ['.localhost'],
    historyApiFallback: true,
    overlay: { warnings: false, errors: true }
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
      }),
      new OptimizeCSSAssetsPlugin({})
    ]
  }
})
