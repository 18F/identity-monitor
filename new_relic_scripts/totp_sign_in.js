require('./bootstrap');

const base32 = require('thirty-two');
const notp = require('notp');
const {
  fillOutOTPForm,
  fillOutSignInForm,
  submitForm,
  verifyCurrentPath,
  visitURL,
} = require('./support/browser');

const {
  LOWER_ENV,
  INT_IDP_URL,
  STAGING_IDP_URL,
  TOTP_SIGN_IN_EMAIL,
  TOTP_SIGN_IN_PASSWORD,
  TOTP_SIGN_IN_TOTP_SECRET,
} = process.env;

const IDP_URL = eval(`${LOWER_ENV.toUpperCase()}_IDP_URL`);

const generateTOTP = () => {
  const decodedTOTPSecret = base32.decode(TOTP_SIGN_IN_TOTP_SECRET);
  return notp.totp.gen(decodedTOTPSecret);
};

visitURL(IDP_URL).then(() =>
  fillOutSignInForm({
    email: TOTP_SIGN_IN_EMAIL,
    password: TOTP_SIGN_IN_PASSWORD,
  })
).then(() =>
  submitForm()
).then(() =>
  verifyCurrentPath('/login/two_factor/authenticator')
).then(() =>
  fillOutOTPForm(generateTOTP())
).then(() =>
  submitForm()
).then(() =>
  verifyCurrentPath('/account')
).then(() =>
  console.log('Done!')
);
