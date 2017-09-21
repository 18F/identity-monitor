const Q = require('q');
const querystring = require('querystring');
const request = require('request');

const {
  TWILIO_SID,
  TWILIO_TOKEN,
} = process.env;
const MAX_OTP_FETCH_ATTEMPTS = 5;

const TWILIO_MESSAGES_URL = [
  'https://api.twilio.com/2010-04-01/Accounts',
  TWILIO_SID,
  'Messages.json'
].join('/');

const getTextMessages = ({ sentAfter, phoneNumber }) => {
  const deferred = Q.defer();
  const requestURL = [
    TWILIO_MESSAGES_URL,
    querystring.stringify({ 'DateSent>': sentAfter.toISOString(), To: phoneNumber }),
  ].join('?');
  request.get(requestURL, {
    auth: { username: TWILIO_SID, password: TWILIO_TOKEN },
  }, (error, response, body) => {
    if (error) {
      deferred.reject(error);
    } else if (response.statusCode !== 200) {
      deferred.reject(
        new Error(`Unexpected Twilio Status: ${response.statusCode}`)
      );
    } else {
      deferred.resolve(JSON.parse(body).messages);
    }
  });
  return deferred.promise;
};

const readOTPFromMessage = (message) => {
  const match = message.body.match(/(\d+) is your login\.gov one-time/);
  if (match) {
    return match[1];
  }
  return null;
};

const getOTPFromTwilio = ({ sentAfter, phoneNumber, attempts = 0 }) => {
  console.log(`Fetching OTP from Twilio, attempt ${attempts + 1}/${MAX_OTP_FETCH_ATTEMPTS}`);
  if (attempts >= MAX_OTP_FETCH_ATTEMPTS) {
    throw new Error('Unable to fetch OTP from Twilio');
  }
  return getTextMessages({
    sentAfter,
    phoneNumber,
  }).then(messages => messages.reduce((currentOTP, message) => {
    const otp = readOTPFromMessage(message);
    if (otp) {
      return otp;
    }
    return currentOTP;
  }, null)).then((otp) => {
    if (otp) {
      return otp;
    }
    return $broswer.sleep(2000).then(() =>
      getOTPFromTwilio({ sentAfter, phoneNumber, attempts: attempts + 1 })
    );
  });
};

module.exports = {
  getOTPFromTwilio,
};
