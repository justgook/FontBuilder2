const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const packageData = require('./package.json')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const FaviconsWebpackPlugin = require('favicons-webpack-plugin')

const uglifyJSOptions = {
  sequences: true, // join consecutive statemets with the "comma operator"
  properties: true, // optimize property access: a["foo"] → a.foo
  dead_code: true, // discard unreachable code
  drop_debugger: true, // discard "debugger" statements
  drop_console: true,
  unsafe: false, // some unsafe optimizations (see below)
  conditionals: true, // optimize if-s and conditional expressions
  comparisons: true, // optimize comparisons
  evaluate: true, // evaluate constant expressions
  booleans: true, // optimize boolean expressions
  loops: true, // optimize loops
  unused: true, // drop unused variables/functions
  hoist_funs: true, // hoist function declarations
  hoist_vars: false, // hoist variable declarations
  if_return: true, // optimize if-s followed by return/continue
  join_vars: true, // join var declarations
  side_effects: true, // drop side-effect-free statements
  warnings: true, // warn about potentially dangerous optimizations/code
  global_defs: {}, // global definitions
};

module.exports = function (env: { waitTime?: Number, fps?: Number, signalingUrl?: String, production: Boolean }) {
  return {
    entry: './src/index.ts',
    output: {
      path: path.resolve(__dirname, 'dist'),
      chunkFilename: '[name].bundle.js',
      filename: 'bundle.js',
    },
    resolve: {
      extensions: ['.ts', '.js'],

      alias: {
        handlebars: 'handlebars/dist/handlebars.min.js'

      }
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
        {
          test: /\.(gif|png|jpe?g|svg)$/i,
          use: [
            'file-loader',
            {
              loader: 'image-webpack-loader',
              options: {
                mozjpeg: {
                  progressive: true,
                  quality: 65
                },
                // optipng.enabled: false will disable optipng
                optipng: {
                  enabled: false,
                },
                pngquant: {
                  quality: '65-90',
                  speed: 4
                },
                gifsicle: {
                  interlaced: false,
                },
                // the webp option will enable WEBP
                webp: {
                  quality: 75
                }
              }
            },
          ],
        }
        // {
        //   test: /\.eval\.js$/,
        //   loader: require.resolve('./scripts/eval-loader.js'),
        // },
      ],
    },
    plugins: [
      (env && env.production)
        ? new UglifyJsPlugin({
          parallel: 8,
          uglifyOptions: {
            ie8: false,
            ecma: 5,
            compress: uglifyJSOptions,
          }
        })
        : new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({ title: (env && env.production) ? (<any>packageData).description : `- DEV - ${(<any>packageData).description} ` }),
      new FaviconsWebpackPlugin({
        inject: true,
        background: '#020307',
        // Your source logo
        logo: './src/assets/logo.png',
        // The prefix for all image files (might be a folder or a name)
        prefix: 'icons-[hash]/',
        // Emit all stats of the generated icons
        emitStats: false,
        // Generate a cache file with control hashes and
        // don't rebuild the favicons until those hashes change
        persistentCache: true,
      }),
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