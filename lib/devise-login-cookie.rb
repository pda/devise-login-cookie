module DeviseLoginCookie

  def success!(resource)
    super
    if succeeded?
      cookies["login_#{scope}_token"] = cookie_values(resource)
    end
  end

  #########
  protected

  def cookie_values(resource)
    value = sign [ resource.id, Time.now.to_i ]
    options = Rails.configuration.session_options.slice(:path, :domain, :secure)
    options.merge! :value => value
    options
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
