Identity Monitor
================

Automated tests for Login.gov


To test Login.gov
-----------------

On Ubuntu:

```bash
$ xvfb-run --auto-servernum bundle exec rspec
```

This produces RSpec output showing the results:

```
Login.gov Demo Site
  should enforce https everywhere
  should have a valid cert
  initial access
    is rejected w/out basic auth
    is accepted w/ proper basic auth login
  creating an account
    has a link trail to the sign-up page

Finished in 0.94019 seconds (files took 0.56581 seconds to load)
5 examples, 0 failures

```