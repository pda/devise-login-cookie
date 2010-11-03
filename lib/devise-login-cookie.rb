module DeviseLoginCookie

  def success!(resource)
    super
    if succeeded?
      cookies.signed["login_#{scope}_token"] = cookie_values(resource)
    end
  end

  #########
  protected

  def cookie_values(resource)
    value = [ resource.id, Time.now.to_i ]
    options = Rails.configuration.session_options.slice(:path, :domain, :secure)
    options.merge! :value => value
    options
  end

  def succeeded?
    @result == :success
  end

end

Devise::Strategies::Authenticatable.send :include, DeviseLoginCookie
