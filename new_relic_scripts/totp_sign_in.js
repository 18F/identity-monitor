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
  IDP_URL,
  NR_TOTP_SIGN_IN_EMAIL,
  NR_TOTP_SIGN_IN_PASSWORD,
  NR_TOTP_SIGN_IN_TOTP_SECRET,
} = process.env;

const generateTOTP = () => {
  const decodedTOTPSecret = base32.decode(NR_TOTP_SIGN_IN_TOTP_SECRET);
  return notp.totp.gen(decodedTOTPSecret);
};

visitURL(IDP_URL).then(() =>
  fillOutSignInForm({
    email: NR_TOTP_SIGN_IN_EMAIL,
    password: NR_TOTP_SIGN_IN_PASSWORD,
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
