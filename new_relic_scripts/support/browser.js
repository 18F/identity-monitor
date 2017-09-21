const { expect } = require('chai');
const url = require('url');

const {
  IDP_URL
} = process.env;

const fillOutOTPForm = (otp) => {
  console.log('Entering OTP');
  return $browser.findElement($driver.By.id('code')).sendKeys(otp);
};

const fillOutSignInForm = ({ email, password }) => {
  console.log('Filling out email');
  return $browser.findElement($driver.By.id('user_email')).sendKeys(email).then(() => {
    console.log('Filling out password');
    return $browser.findElement($driver.By.id('user_password')).sendKeys(password);
  });
};

const idpUrl = (path) => {
  const ipdUrl = url.parse(IDP_URL);
  ipdUrl.auth = null;
  return ipdUrl.resolve(path);
};

const submitForm = () => {
  console.log('Clicking the submit button');
  return $browser.findElement($driver.By.name('commit')).click();
};

const verifyCurrentPath = (expectedPath) => {
  const expectedUrl = idpUrl(expectedPath);
  console.log(`Verifying that current url equals ${expectedUrl}`);

  return $browser.sleep(1000).then(() =>
    $browser.getCurrentUrl()
  ).then((currentUrl) => {
    expect(currentUrl).to.eq(expectedUrl);
  });
};

const visitURL = (targetUrl) => {
  console.log(`Visiting ${targetUrl}`);
  return $browser.get(targetUrl);
};

module.exports = {
  fillOutOTPForm,
  fillOutSignInForm,
  submitForm,
  verifyCurrentPath,
  visitURL,
};
