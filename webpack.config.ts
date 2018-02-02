const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const packageData = require('./package.json')
const webpack = require('webpack')

module.exports = function (env: { waitTime?: Number, fps?: Number, signalingUrl?: String, production: Boolean }) {
  return {
    entry: './src/index.ts',
    output: {
      path: path.resolve(__dirname, 'dist'),
      chunkFilename: '[name].bundle.js',
      filename: 'bundle.js',
    },
    resolve: {
      extensions: ['.ts', '.js']
    },
    module: {
      loaders: [
        {
          test: /\.ts$/,
          use: 'ts-loader',
          exclude: /node_modules/
        },
        {
          test: /\.css$/,
          use: ['style-loader', 'css-loader']
        },
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: 'elm-hot-loader',
            },
            {
              loader: 'elm-webpack-loader',
              options: {
                maxInstances: 8
              }

            }],
        },
        // {
        //   test: /\.eval\.js$/,
        //   loader: require.resolve('./scripts/eval-loader.js'),
        // },
      ],
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({ title: (env && env.production) ? (<any>packageData).description : `- DEV - ${(<any>packageData).description} ` }),
      new webpack.optimize.ModuleConcatenationPlugin(),
      new webpack.NamedModulesPlugin(),
    ],
    devServer: {
      host: '0.0.0.0',
      inline: true,
      stats: 'errors-only',
      contentBase: path.join(__dirname, 'dist'),
      port: (<any>packageData).config.port,
      hot: true,
      open: true,
      overlay: true,
    },
  }
}