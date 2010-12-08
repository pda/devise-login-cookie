require "active_support/core_ext/hash/slice"

module DeviseLoginCookie

  class Cookie

    # for non-Rails test environment.
    attr_writer :session_options
    attr_accessor :secret_token

    def initialize(cookies, scope)
      @cookies = cookies
      @scope = scope
    end

    # Sets the cookie, referencing the given resource.id (e.g. User)
    def set(resource)
      @cookies[cookie_name] = cookie_options.merge(:value => encoded_value(resource))
    end

    # Unsets the cookie via the HTTP response.
    def unset
      @cookies.delete cookie_name, cookie_options
    end

    # The id of the resource (e.g. User) referenced in the cookie.
    def id
      value[0]
    end

    # The Time at which the cookie was created.
    def created_at
      valid? ? Time.at(value[1]) : nil
    end

    # Whether the cookie appears valid.
    def valid?
      present? && value.all?
    end

    def present?
      @cookies[cookie_name].present?
    end

    # Whether the cookie was set before the given Time
    def set_before?(time)
      created_at && created_at < time
    end

    private

    def value
      begin
        @value = signer.decode @cookies[cookie_name]
      rescue SignedJson::Error
        [nil, nil]
      end
    end

    def cookie_name
      :"login_#{@scope}_token"
    end

    def encoded_value(resource)
      signer.encode [ resource.id, Time.now.to_i ]
    end

    def cookie_options
      @session_options ||= Rails.configuration.session_options
      @session_options.slice(:path, :domain, :secure, :httponly)
    end

    def signer
      require 'signed_json'
      secret = secret_token || Rails.configuration.secret_token
      @signer ||= SignedJson::Signer.new(secret)
    end

  end

end
