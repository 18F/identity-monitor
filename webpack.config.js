require('dotenv').config();

const path = require('path');
const webpack = require('webpack');

// Whitelist specific env variables for use in DefinePlugin below
const environmentVariables = [
  'IDP_URL',
  'NR_TOTP_SIGN_IN_EMAIL',
  'NR_TOTP_SIGN_IN_PASSWORD',
  'NR_TOTP_SIGN_IN_TOTP_SECRET',
].reduce((variables, key) => {
  const name = `process.env.${key}`;
  return Object.assign(variables, { [name]: JSON.stringify(process.env[key]) });
}, {});

module.exports = {
  entry: {
    totp_sign_in: './new_relic_scripts/totp_sign_in.js',
  },
  output: {
    path: path.resolve(__dirname, 'new_relic_scripts_out'),
    filename: '[name].bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015'],
          },
        },
      },
    ],
  },
  plugins: [
    new webpack.IgnorePlugin(/selenium-webdriver/),
    new webpack.DefinePlugin(environmentVariables),
    new webpack.optimize.UglifyJsPlugin(),
  ],
};
