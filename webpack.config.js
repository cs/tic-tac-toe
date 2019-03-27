const CopyPlugin = require('copy-webpack-plugin');
const HtmlPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin")
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const glob = require("glob")
const path = require('path')
const webpack = require('webpack')

const commonFlags = {
}

const developmentFlags = Object.assign({}, commonFlags, {
  base: '/'
})

const productionFlags = Object.assign({}, commonFlags, {
  googleAnalyticsTrackingId: process.env.GOOGLE_ANALYTICS_TRACKING_ID,
  base: `/${process.env.GIT_REVISION ? process.env.GIT_REVISION + '/' : ''}`
})

const context = path.join(__dirname, 'src')
const chunks = glob.sync('index.*.js', { cwd: context })
                   .map(filename => filename.match(/^index\.(.*)\.js$/)[1])
const defaultChunk = chunks.includes('default') ? 'default' : chunks[0];

module.exports = (env, { mode = 'development' }) => ({
  context,
  entry: Object.assign(...chunks.map(chunk => ({ [chunk]: `./index.${chunk}.js` }))),
  output: {
    filename: 'bundle.[name].js',
    path: path.join(__dirname, 'build'),
    library: 'Main'
  },
  mode: mode,
  plugins: [
    new CopyPlugin(['assets']),
    ...chunks.map(chunk =>
      new HtmlPlugin({
        template: 'index.html.ejs',
        filename: `index.${chunk}.html`,
        chunks: [chunk],
        inject: false,
        flags: mode === 'production' ? productionFlags : developmentFlags
      })
    ),
    new MiniCssExtractPlugin({ filename: "bundle.[name].css" })
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
      use: [
        MiniCssExtractPlugin.loader,
        { loader: 'css-loader', options: { url: false } }
      ]
    }]
  },
  devServer: {
    port: 3000,
    allowedHosts: ['.localhost'],
    historyApiFallback: {
      rewrites: [
        {
          to: ({ request }) => {
            let chunk = defaultChunk
            let subdomain = request.hostname.match(/^(.*)\.localhost$/)
            if (subdomain && chunks.includes(subdomain[1])) { chunk = subdomain[1] }
            return `/index.${chunk}.html`
          }
        }
      ]
    },
    overlay: { warnings: false, errors: true }
  },
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        uglifyOptions: {
          compress: {
            pure_funcs: [ 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9' ],
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
