const webpack = require('webpack');
const path = require('path');
var BundleTracker = require('webpack-bundle-tracker');


const outputPath = path.resolve('./static/js/dist/');

module.exports = {
  entry: [
    'webpack-dev-server/client?http://localhost:3000',
    'webpack/hot/dev-server',
    './static/js/app/index',
  ],
  output: {
    path: outputPath,
    filename: '[name]-[hash].js',
    publicPath: 'http://localhost:3000/static/js/dist/',
  },
  resolve: {
    root: [
      path.resolve('./static/js/app'),
    ],
    modulesDirectories: ['node_modules', 'bower_components'],
    extensions: ['', '.js', '.jsx'],
  },
  devtool: 'eval-source-map',
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new BundleTracker({filename: './webpack-stats.json'}),
  ],
  module: {
    loaders: [
      {
        test: /\.js?$/,
        loaders: ['babel'],
        include: path.join(__dirname, 'static/js')
      }
    ]
  },
}
