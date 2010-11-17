module DeviseLoginCookie

  def success!(resource)
    super
    if succeeded?
      cookies["login_#{scope}_token"] = cookie_values(resource)
    end
  end

  def self.delete_cookie(record, warden, options)
    warden.cookies.delete("login_#{options[:scope]}_token", cookie_options)
  end

  #########
  protected

  def cookie_options
    Rails.configuration.session_options.slice(:path, :domain, :secure, :httponly)
  end

  def cookie_values(resource)
    value = sign [ resource.id, Time.now.to_i ]
    cookie_options.merge :value => value
  end

  def succeeded?
    @result == :success
  end

  #######
  private

  def sign(input)
    require 'signed_json'
    signer = SignedJson::Signer.new(Rails.configuration.secret_token)
    signer.encode input
  end

end

Devise::Strategies::Authenticatable.send :include, DeviseLoginCookie

Warden::Manager.before_logout do |record, warden, options|
  DeviseLoginCookie::delete_cookie record, warden, options
end
