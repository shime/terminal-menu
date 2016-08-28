# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/terminal-menu/version"

Gem::Specification.new do |s|
  s.name         = "terminal-menu"
  s.version      = TerminalMenu::VERSION
  s.authors      = ["Hrvoje Simic"]
  s.email        = "shime@twobucks.co"
  s.homepage     = "https://github.com/twobucks/terminal-menu"
  s.summary      = "Terminal menu"
  s.description  = "Retro ANSI terminal menu"
  s.license      = 'MIT'
  s.require_path = 'lib'

  s.files = %w[
    README.md
    LICENSE
    terminal-menu.gemspec
    lib/terminal-menu.rb
    lib/terminal-menu/version.rb
  ]

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency 'paint', '~> 1.0', '>= 1.0.1'

  s.add_development_dependency 'minitest', '~> 5.9', '>= 5.9.0'
  s.add_development_dependency 'rake', '~> 11.2', '>= 11.2.2'
end
