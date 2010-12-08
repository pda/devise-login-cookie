require "rails"
require "devise"
require "devise_login_cookie"

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

  end
end
