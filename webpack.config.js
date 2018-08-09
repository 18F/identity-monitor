require('dotenv').load();

const path = require('path');
const webpack = require('webpack');

// Whitelist specific env variables for use in DefinePlugin below
const environmentVariables = [
  'IDP_URL',
  'SMS_SIGN_IN_EMAIL',
  'SMS_SIGN_IN_PASSWORD',
  'SMS_SIGN_IN_TWILIO_PHONE',
  'TOTP_SIGN_IN_EMAIL',
  'TOTP_SIGN_IN_PASSWORD',
  'TOTP_SIGN_IN_TOTP_SECRET',
  'TWILIO_SID',
  'TWILIO_TOKEN',
].reduce((variables, key) => {
  const name = `process.env.${key}`;
  return Object.assign(variables, { [name]: JSON.stringify(process.env[key]) });
}, {});

module.exports = {
  entry: {
    totp_sign_in: './new_relic_scripts/totp_sign_in.js',
    sms_sign_in: './new_relic_scripts/sms_sign_in.js',
  },
  externals: {
    chai: 'commonjs chai',
    crypto: 'commonjs crypto',
    q: 'commonjs q',
    querystring: 'commonjs querystring',
    request: 'commonjs request',
    url: 'commonjs url',
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
    new webpack.IgnorePlugin(/selenium-webdriver|dotenv/),
    new webpack.DefinePlugin(environmentVariables),
  ],
  target: 'node',
};
