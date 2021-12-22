# ModSecurity reCAPTCHA
ModSecurity library for reCAPTCHA validation.

# Requirements
 * lua-http library

# Usage example
```
SecAction \
    "id:10000,\
    phase:1,\
    nolog,\
    pass,\
    t:none,\
    setvar:'tx.recaptcha_secret_key=<secret/private_key_here>'"

SecRule &ARGS:g-recaptcha-response "@gt 0" \
    "id:10001,\
    phase:2,\
    deny,\
    t:none,\
    msg:'reCAPTCHA validation failed.',\
    logdata:'reCAPTCHA validation failed.',\
    chain"
    SecRule ARGS:g-recaptcha-response "@inspectFile recaptcha.lua" "t:none"
```
