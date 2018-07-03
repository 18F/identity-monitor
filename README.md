Identity Monitor
================

Automated tests for Login.gov

[![Code Climate](https://codeclimate.com/github/18F/identity-monitor/badges/gpa.svg)](https://codeclimate.com/github/18F/identity-monitor)


To test Login.gov
-----------------

Create a new Google email and voice account. Don't use your primary Google email
account because the tests will clear your inbox! The Google voice account is
important because the tests assume that the text message that was sent to the
phone will be forwarded to your email. Verify that "Forward messages to email"
is turned on in your [Google Voice settings](https://voice.google.com/settings).

Create a `.env` file with the Google credentials and phone number:

```bash
$ cp .env.example .env
$ vi .env
```

Note that if your Google account uses 2FA, you will need to create an
[App password](https://myaccount.google.com/apppasswords) and use that as the
value of `EMAIL_PASSWORD`. To create the app password, Choose "Mail" from the
"Select app" dropdown and "Other" from "Select device".

Make sure that `TWILIO_SID` and `TWILIO_TOKEN` correspond to the Figaro config
values `twilio_sid` and `twilio_auth_token` in the environment that are you
are currently testing (based on `IDP_URL`).

Install dependencies:

```bash
$ bundle install
```

Run the tests:

```bash
$ make test
```

Note about Voice OTP testing
----------------------------
Google Voice transcription is not very accurate with the passcodes. We've tried
to account for the most common scenarios, but it's possible the code won't be
correctly transcribed. If a Voice OTP spec fails, try running it again.

To create scripts for New Relic monitoring
------------------------------------------

To create scripts for New Relic monitoring:

- Run `npm install` to install dependencies
- Run `make build_nr_scripts` to write the scripts to new_relic_scripts_out

After running `npm install`, the scripts can be tested locally using:

```
node new_relic_scripts/<script-name>.js
```

After the scripts are built, they can be added to
[New Relic Synthetics](https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/using-monitors/add-edit-monitors).

For the scripts to be build properly, some environment variables may need to be
set according to the instructions below.

### TOTP Sign in

Create a test user on Login.gov. Setup TOTP for the user an save the TOTP code.
Afterwards, add the following to your `.env`:

- `IDP_URL`: The IDP url to run the script against
- `NR_TOTP_SIGN_IN_EMAIL`: The user's email address
- `NR_TOTP_SIGN_IN_PASSWORD`: The user's password
- `NR_TOTP_SIGN_IN_TOTP_SECRET`: The user's TOTP secret, received when setting
   up TOTP
