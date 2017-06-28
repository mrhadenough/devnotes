const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: './static/js/',
  output: {
    path: path.join(__dirname, 'static'),
    filename: '[name]-[hash].js',
    publicPath: '/static/js/dist',
  },
  resolve: {
    extensions: ['', '.js'],
  },
  devtool: 'source-map',
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ],
  module: {
    loaders: [
      {
        test: /\.js?$/,
        loaders: ['babel'],
        include: path.join(__dirname, 'static/js')
      }
    ]
  }
};
