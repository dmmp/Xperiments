var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");

var path = require('path');

module.exports = {
  entry: ['whatwg-fetch', "./web/static/js/application.es6"],
  output: {
    path: path.resolve(__dirname, "./priv/static"),
    filename: "js/app.js"
  },

  resolve: {
    modulesDirectories: ["node_modules", path.resolve(__dirname, "./web/static/js")]
  },

  module: {
    loaders: [{
      test: /\.(es6|jsx|js)$/,
      exclude: /node_modules/,
      loader: 'babel-loader',
      include: __dirname,
      query: {
        presets: ["es2015", "react", "react-optimize", "stage-0"]
      }
    }, {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract("style", "css")
    }]
  },

  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./web/static/assets" }])
  ]

};
