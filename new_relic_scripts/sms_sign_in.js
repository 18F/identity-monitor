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
  IDP_URL,
  NR_SMS_SIGN_IN_EMAIL,
  NR_SMS_SIGN_IN_PASSWORD,
  NR_SMS_SIGN_IN_TWILIO_PHONE
} = process.env;

visitURL(IDP_URL).then(() =>
  fillOutSignInForm({
    email: NR_SMS_SIGN_IN_EMAIL,
    password: NR_SMS_SIGN_IN_PASSWORD,
  })
).then(() =>
  submitForm()
).then(() =>
  verifyCurrentPath('/login/two_factor/sms?reauthn=false')
).then(() =>
  getOTPFromTwilio({
    phoneNumber: NR_SMS_SIGN_IN_TWILIO_PHONE,
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
