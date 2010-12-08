require "devise_login_cookie/cookie"

Warden::Manager.after_set_user do |user, warden, options|
  DeviseLoginCookie::Cookie.new(warden, options[:scope]).set(user)
end

Warden::Manager.before_logout do |user, warden, options|
  DeviseLoginCookie::Cookie.new(warden, options[:scope]).unset
end
