devise-login-cookie
===================

An extension for Devise which sets a signed login cookie upon authentication, making shared logins between same-domain applications possible.


Installation
------------

    gem install devise-login-cookie

    echo 'gem "devise-login-cookie"' >> Gemfile
    bundle install

    # load in config/initializers/devise
    require 'devise-login-cookie'


Information
-----------

While Devise sets a cookie for Remember Me logins, standard logins are only tracked in the session.
This extension sets a separate cookie upon authentication.


TODO
----

* Cookie is being set on signin; need to delete on signout.
* Cookie is write-only; create a Warden strategy to consume cookie for login.
* Rails signed cookies use Marshal.dump; implement a simpler cross-platform HMAC signing.


Meh
---

(c) 2010 Paul Annesley, MIT license.
