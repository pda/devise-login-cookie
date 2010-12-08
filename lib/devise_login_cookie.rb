module DeviseLoginCookie

  class Cookie

    def initialize(warden, scope)
      @scope = scope
      @warden = warden
    end

    def set(user)
      cookies[cookie_name] = cookie_options.merge(:value => cookie_value(user))
    end

    def unset
      cookies.delete cookie_name, cookie_options
    end

    private

    def cookies
      # .cookies provided by Devise in warden_compat.rb
      # Roughly equivalent to: ActionDispatch::Request.new(env).cookie_jar
      @warden.cookies
    end

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

  Warden::Manager.after_set_user do |user, warden, options|
    Cookie.new(warden, options[:scope]).set(user)
  end

  Warden::Manager.before_logout do |user, warden, options|
    Cookie.new(warden, options[:scope]).unset
  end

end
