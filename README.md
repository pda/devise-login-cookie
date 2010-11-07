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

For the `:user` scope, the cookie is named `login_user_token`, consistent with `remember_user_token` from rememberable.

The cookie is deleted via the before_logout Warden hook.


TODO
----

* Cookie is write-only; create a Warden strategy to consume cookie for login.


Meh
---

(c) 2010 Paul Annesley, MIT license.
