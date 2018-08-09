Identity Monitor
================

Automated tests for Login.gov

[![Code Climate](https://codeclimate.com/github/18F/identity-monitor/badges/gpa.svg)](https://codeclimate.com/github/18F/identity-monitor)


To test Login.gov
-----------------

We have a dummy Google email and voice account used for running these smoke
tests. The credentials are in a `.env` file that you can fetch using the
instructions in the Release Management Wiki. If for some reason, the dummy
account no longer works, you can create your own Google email and voice account.
Don't use your primary Google email account because the tests will clear your
inbox! If you end up using your own account, follow the instructions below.
Otherwise, skip to [Run the tests](#run-the-tests).

Google Voice Settings
---------------------
Make sure the following are enabled in your [Google Voice settings](https://voice.google.com/settings):

### Phone numbers
- Add a linked number
- Turn on "Do not disturb"

### Messages
- Turn on "Forward messages to email"

### Calls
- Check "Forward calls to linked numbers"

### Voicemail
- Turn on "Get voicemail via email"
- Turn on "Let Google analyze voicemail transcripts"

Note that if your Google account uses 2FA, you will need to create an
[App password](https://myaccount.google.com/apppasswords) and use that as the
value of `EMAIL_PASSWORD`. To create the app password, Choose "Mail" from the
"Select app" dropdown and "Other" from "Select device".

Run the tests
-------------

```bash
$ bundle install
```

```bash
$ make test LOWER_ENV=int
```

### Testing `int` and `staging`
To specify the lower environment when running tests, set the `LOWER_ENV` env var,
as shown above.

### Note about test failures
Sometimes specs might fail because they weren't able to parse the OTP code
from Google. If a particular spec fails, try running it again. We've had good
luck running each feature spec file one at a time.

To create scripts for New Relic monitoring
------------------------------------------

- Run `npm install` to install dependencies
- Run `make build_nr_scripts` to write the scripts to new_relic_scripts_out

After running `npm install`, the scripts can be tested locally using:

```
node new_relic_scripts/<script-name>.js
```

After the scripts are built, they can be added to
[New Relic Synthetics](https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/using-monitors/add-edit-monitors).
