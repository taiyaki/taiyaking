# -*- ruby -*-

source "http://rubygems.org"

gem "rails", "3.2.3"

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'warden-openid'
gem 'devise', "2.0.4"
gem 'bluefeather'
gem 'kaminari'
gem 'racknga'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes

  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails', ">= 2.1.0"
end

group :deploy do
  gem 'capistrano'
end
