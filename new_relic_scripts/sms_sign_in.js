require('./bootstrap');

const {
  fillOutOTPForm,
  fillOutSignInForm,
  submitForm,
  verifyCurrentPath,
  visitURL,
} = require('./support/browser');
const { getOTPFromTwilio } = require('./support/twilio_helpers');

const {
  LOWER_ENV,
  INT_IDP_URL,
  STAGING_IDP_URL,
  SMS_SIGN_IN_EMAIL,
  SMS_SIGN_IN_PASSWORD,
  SMS_SIGN_IN_TWILIO_PHONE
} = process.env;

const IDP_URL = eval(`${LOWER_ENV.toUpperCase()}_IDP_URL`);

visitURL(IDP_URL).then(() =>
  fillOutSignInForm({
    email: SMS_SIGN_IN_EMAIL,
    password: SMS_SIGN_IN_PASSWORD,
  })
).then(() =>
  submitForm()
).then(() =>
  verifyCurrentPath('/login/two_factor/sms?reauthn=false')
).then(() =>
  getOTPFromTwilio({
    phoneNumber: SMS_SIGN_IN_TWILIO_PHONE,
    // 30 second padding necessary for Twilio to return the message
    sentAfter: new Date(Date.now() - 30000),
  })
).then(otp =>
  fillOutOTPForm(otp)
).then(() =>
  submitForm()
).then(() =>
  verifyCurrentPath('/account')
).then(() =>
  console.log('Done!')
);
