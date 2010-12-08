require "rails"
require "devise"
require "devise_login_cookie"
require "action_dispatch/middleware/cookies"

module DeviseLoginCookie

  module SpecHelpers

    def resource(id)
      require "ostruct"
      OpenStruct.new(:id => id)
    end

    def cookie_jar(cookies = {})
      ActionDispatch::Cookies::CookieJar.new.tap do |jar|
        cookies.each { |key, value| jar[key] = value }
      end
    end

    def create_cookie(cookies = {})
      Cookie.new(cookie_jar(cookies), :test).tap do |cookie|
        cookie.session_options = {}
        cookie.secret_token = "secret"
      end
    end

    def create_valid_cookie(id, created_at)
      create_cookie :login_test_token => signed_cookie_value(id, created_at.to_i)
    end

    def signed_cookie_value(id, created_at)
      # hacky shortcut better than re-implementing?
      Cookie.new(nil, nil).tap do |cookie|
        cookie.secret_token = "secret"
      end.send(:signer).encode [id, created_at]
    end

    def create_strategy(cookies = {})
      env = { "action_dispatch.cookies" => cookie_jar(cookies) }
      Strategy.new(env, :test).tap do |strategy|
        strategy.secret_token = "secret"
      end
    end

    def create_valid_strategy
      create_strategy :login_test_token => signed_cookie_value(1, Time.now.to_i)
    end

  end

end
