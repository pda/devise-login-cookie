require "devise_login_cookie/cookie"

Warden::Manager.after_set_user do |user, warden, options|
  DeviseLoginCookie::Cookie.new(warden.cookies, options[:scope]).set(user)
end

Warden::Manager.before_logout do |user, warden, options|
  DeviseLoginCookie::Cookie.new(warden.cookies, options[:scope]).unset
end
