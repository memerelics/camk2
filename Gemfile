source 'https://rubygems.org'

# Rails should be higher than  3.2.11,
# because of vulnerability in parameter parsing in the Action Pack framework
gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'devise'
gem 'oauth'
gem 'omniauth-evernote'
gem 'evernote-thrift'
gem 'slim'

gem 'pry'
gem 'pry-doc'
gem 'pry-rails'
gem 'json'
gem 'hashie'
gem 'awesome_print'

# -> publish
gem 'mechanize'
gem 'nokogiri'
gem 'wsse'
gem 'redcarpet'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'less-rails' # when using less type bootstrap
gem 'therubyracer'

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end
group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'spork', '~> 1.0rc'
  gem 'fuubar' # usage: --format Fuubar in .rspec
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  # faster Guard
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end
