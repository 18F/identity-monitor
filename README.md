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

ENV Vars
--------

Create a `.env` file with the Google credentials and phone number:

```bash
$ cp .env.example .env
$ vi .env
```

Make sure that `TWILIO_SID` and `TWILIO_TOKEN` correspond to the Figaro config
values `twilio_sid` and `twilio_auth_token` in the environment that are you
are currently testing (based on `IDP_URL`).

Run the tests
-------------

```bash
$ bundle install
```

```bash
$ make test
```

### Testing `int` and `staging`
By default, the tests use the `int` server. To run the smoke tests
against staging, using USAJOBS as the SP, comment out `SP_URL` and `IDP_URL`
in the `INT` section of your `.env`, and uncomment `SP_URL` and `IDP_URL` in
the `STAGING` section.

### Note about Voice OTP testing
Google Voice transcription is not very accurate with the passcodes. We've tried
to account for the most common scenarios, but it's possible the code won't be
correctly transcribed. If a Voice OTP spec fails, try running it again.

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

For the scripts to be build properly, some environment variables may need to be
set according to the instructions below.

### TOTP Sign in

Create a test user on Login.gov. Setup TOTP for the user and save the TOTP code.
Afterwards, add the following to your `.env`:

- `IDP_URL`: The IDP url to run the script against
- `NR_TOTP_SIGN_IN_EMAIL`: The user's email address
- `NR_TOTP_SIGN_IN_PASSWORD`: The user's password
- `NR_TOTP_SIGN_IN_TOTP_SECRET`: The user's TOTP secret, received when setting
   up TOTP
