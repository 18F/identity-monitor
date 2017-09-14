const base32 = require('thirty-two');
const { expect } = require('chai');
const notp = require('notp');
const url = require('url');

const {
  IDP_URL,
  NR_TOTP_SIGN_IN_EMAIL,
  NR_TOTP_SIGN_IN_PASSWORD,
  NR_TOTP_SIGN_IN_TOTP_SECRET,
} = process.env;

// Initialize $browser and $driver if we are local and not on New Relic
try {
  // eslint-disable-next-line no-unused-expressions
  $browser && $driver;
} catch (error) {
  $driver = require('selenium-webdriver');
  $browser = new $driver.Builder().forBrowser('chrome').build();
}

const generateTOTP = () => {
  const decodedTOTPSecret = base32.decode(NR_TOTP_SIGN_IN_TOTP_SECRET);
  return notp.totp.gen(decodedTOTPSecret);
};

const idpURL = (path) => {
  const ipdUrl = url.parse(IDP_URL);
  ipdUrl.auth = null;
  return ipdUrl.resolve(path);
};

$browser.get(IDP_URL).then(() => {
  console.log('Filling out email');
  return $browser.findElement($driver.By.id('user_email')).sendKeys(NR_TOTP_SIGN_IN_EMAIL);
}).then(() => {
  console.log('Filling out password');
  return $browser.findElement($driver.By.id('user_password')).sendKeys(NR_TOTP_SIGN_IN_PASSWORD);
}).then(() => {
  console.log('Clicking the submit button');
  return $browser.findElement($driver.By.name('commit')).click();
}).then(() => {
  console.log('Verifying that URL is 2FA URL');
  return $browser.getCurrentUrl();
}).then((currentUrl) => {
  // Current URL should be authenticator 2FA
  expect(currentUrl).to.eq(idpURL('/login/two_factor/authenticator'));

  // Fill in TOTP field with TOTP
  console.log('Entering TOTP');
  return $browser.findElement($driver.By.id('code')).sendKeys(generateTOTP());
}).then(() => {
  console.log('Clicking the submit button');
  return $browser.findElement($driver.By.name('commit')).click();
}).then(() => {
  console.log('Verifying that URL is account URL');
  return $browser.getCurrentUrl();
}).then((currentUrl) => {
  expect(currentUrl).to.eq(idpURL('/account'));
  console.log('Done!');
});
