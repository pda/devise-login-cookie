devise-login-cookie
===================

A simple [Devise][1] extension for Single Sign On across same-domain web applications, using an [HMAC][2] signed login cookie.  The cookie expiry is session-bound, and also contains a tamper-proof creation timestamp for server-enforced expiry.

[`OpenSSL::HMAC`][3] signing is performed by [`signed_json`][4] which also has implementations in PHP and Python, and can easily be implemented in other languages with OpenSSL and JSON. Note that standard Rails signed cookies are not appropriate for cross-platform use, as they use `Marshal.dump` internally.

  [1]: https://github.com/plataformatec/devise
  [2]: http://en.wikipedia.org/wiki/HMAC
  [3]: http://ruby-doc.org/ruby-1.9/classes/OpenSSL/HMAC.html
  [4]: https://github.com/pda/signed_json


Installation
------------

Simple:

    gem install devise-login-cookie

Bundler-style:

    echo 'gem "devise-login-cookie"' >> Gemfile
    bundle install

Rails:

    # in config/initializers/devise.rb inside Devise.setup block
    require 'devise-login-cookie'
    config.warden do |manager|
      manager.default_strategies(:scope => :user) << :devise_login_cookie
    end


Background
----------

The `devise-login-cookie` extension was born from a web application composed of Rails, PHP and Django.  Because the components were on the same domain, Single Sign On could be implemented with a simple shared cookie.

While Devise can set a cookie for Remember Me logins, standard logins are only tracked in the session.  Also, Devise cookies and Rails session cookies are tied to Ruby due to their reliance on `Marshal.dump`.

This extension sets a separate cookie upon authentication, signed in a cross-platform manner, and deletes it via the `before_logout` Warden hook.  For the `:user` scope, the cookie is named `login_user_token`, consistent with `remember_user_token` from Devise's `rememberable`.  The same cookie, if valid, triggers authentication.


Development and Tests
---------------------

Patches are welcome; fork and send a pull request.  Make sure the tests still work, and where possible, add to them.  Let me know if you can't get the tests green to begin with.

RSpec 2 specifications cover the entire `Cookie` and part of the `Strategy`, but do not reach resource loading and authentication, nor cookie setting being triggered by login.  These aspects need tobe tested in the host Rails application.


    $ rake
    
    DeviseLoginCookie::Cookie
      #unset
        deletes cookie
      without any cookies
        Cookie instance
          should not be present
          should not be valid
          should not be set since 1970-01-01 10:00:00 +1000
        #id
          should be nil
        #created_at
          should be nil
        #set
          accepts resource
      with an invalid cookie
        Cookie instance
          should be present
          should not be valid
          should not be set since 1970-01-01 10:00:00 +1000
        #id
          should be nil
        #created_at
          should be nil
        #set
          accepts resource
      with a valid cookie
        Cookie instance
          should be present
          should be valid
          should not be set since 2010-12-08 23:46:30 +1100
          should be set since 2010-12-08 23:46:29 +1100
          should be set since 2010-12-08 23:46:28 +1100
        #id
          should == 5
        #created_at
          should == 2010-12-08 23:46:29 +1100
        #set
          accepts resource
    
    DeviseLoginCookie::Strategy
      #valid?
        with no cookies
          should not be valid
        with invalid cookie
          should not be valid
        with valid cookie
          should be valid
    
    Finished in 0.06065 seconds
    24 examples, 0 failures
    

Credits
-------

(c) 2010 Paul Annesley; MIT Licence.
