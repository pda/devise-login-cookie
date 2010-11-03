# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise-login-cookie/version"

Gem::Specification.new do |s|
  s.name        = "devise-login-cookie"
  s.version     = DeviseLoginCookie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Annesley"]
  s.email       = ["paul@annesley.cc"]
  s.homepage    = "http://rubygems.org/gems/devise-login-cookie"
  s.summary     = %q{Devise extension which sets a login cookie, for easier sharing of login between applications}
  s.description = %q{Devise sets a "remember_token" cookie for Remember Me logins, but not for standard logins.  This extension sets a separate cookie on login, which makes sharing login state between same-domain web applications easier.}

  s.rubyforge_project = "devise-login-cookie"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("devise", ["~> 1.1.0"])

end
