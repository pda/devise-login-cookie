module DeviseLoginCookie

  class Cookie

    attr_reader :cookies

    def initialize(cookies, scope)
      @cookies = cookies
      @scope = scope
    end

    def set(user)
      cookies[cookie_name] = cookie_options.merge(:value => cookie_value(user))
    end

    def unset
      cookies.delete cookie_name, cookie_options
    end

    private

    def cookie_name
      "login_#{@scope}_token"
    end

    def cookie_value(user)
      sign [ user.id, Time.now.to_i ]
    end

    def cookie_options
      Rails.configuration.session_options.slice(:path, :domain, :secure, :httponly)
    end

    def sign(input)
      require 'signed_json'
      signer = SignedJson::Signer.new(Rails.configuration.secret_token)
      signer.encode input
    end

  end

end
