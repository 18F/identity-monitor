Identity Monitor
================

Automated tests for Login.gov

[![Code Climate](https://codeclimate.com/github/18F/identity-monitor/badges/gpa.svg)](https://codeclimate.com/github/18F/identity-monitor)


To test Login.gov
-----------------

Create a Google email and voice account.

Create a `.env` file with the Google credentials and phone number:

```bash
$ cp .env.example .env
$ vi .env
```

Install dependencies:

```bash
$ bundle install
```

Run the tests:

```bash
$ make test
```

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
