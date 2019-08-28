# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_opening_closing_times/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_opening_closing_times'
  s.version     = SolidusOpeningClosingTimes::VERSION
  s.summary     = 'Add opening and closing times to store (for retail)'
  s.description = 'Add opening and closing times to store (for retail)'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Luay Bseiso'
  s.email     = 'luay@buttercloud.com'
  s.homepage  = 'http://www.buttercloud.com'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core', '>= 2.8.3'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '0.37.2'
  s.add_development_dependency 'rubocop-rspec', '1.4.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
