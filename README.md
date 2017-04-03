Identity Monitor
================

Automated tests for Login.gov


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

