// Initialize $browser and $driver if we are local and not on New Relic
try {
  // eslint-disable-next-line no-unused-expressions
  $browser && $driver;
} catch (error) {
  global.$driver = require('selenium-webdriver');
  global.$browser = new $driver.Builder().forBrowser('chrome').build();
  require('dotenv').load();
}
