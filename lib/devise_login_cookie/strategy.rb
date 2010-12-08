module DeviseLoginCookie

  class Strategy < ::Devise::Strategies::Authenticatable

    # TODO: configurable TTL
    COOKIE_TTL = 86400 # one day

    # for non-Rails test environment.
    attr_accessor :secret_token

    def valid?
      cookie.valid?
    end

    def authenticate!
      if fresh?(cookie) && validate(resource)
        success!(resource)
      else
        pass
      end
    end

    private

    def cookie
      @cookie ||= Cookie.new(cookies, scope).tap do |cookie|
        cookie.secret_token = secret_token if secret_token
      end
    end

    def fresh?(cookie)
      cookie.set_before?(Time.now - COOKIE_TTL)
    end

    def resource
      @resource ||= mapping.to.find(cookie.id)
    end

    def pass
      cookie.unset
      super
    end
  end

end