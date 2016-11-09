Identity Monitor
================

Automated tests for Login.gov


To test Login.gov
-----------------

On Ubuntu:

```bash
$ xvfb-run --auto-servernum bundle exec rspec
```

This produces results in the form of RSpec output:


Login.gov Demo Site  
&nbsp;&nbsp;**should enforce https everywhere**  
&nbsp;&nbsp;**should have a valid cert**  
&nbsp;&nbsp;initial access  
&nbsp;&nbsp;&nbsp;&nbsp;**is rejected w/out basic auth**  
&nbsp;&nbsp;&nbsp;&nbsp;**is accepted w/ proper basic auth login**  
&nbsp;&nbsp;creating an account  
&nbsp;&nbsp;&nbsp;&nbsp;**has a link trail to the sign-up page**  

Finished in 0.94019 seconds (files took 0.56581 seconds to load)  
**5 examples, 0 failures**
