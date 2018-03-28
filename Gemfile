source 'https://rubygems.org'

ruby '2.3.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails'
gem 'honeybadger', '~> 3.1'
gem 'hydra-role-management'
gem 'hyrax', '2.0.0'
gem 'nokogiri', '>=1.8.2' # 1.8.2 fixes security issue https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15412
gem 'okcomputer'
gem 'rack-protection', '~> 2.0.1' # 2.0.1 fixes security issue https://github.com/sinatra/sinatra/pull/1379
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'whenever', require: false

gem 'blacklight_advanced_search'

gem 'tufts-curation', github: 'curationexperts/tufts-curation', tag: 'v1.0.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Include deployments scripting only in development environment
  gem 'capistrano', '~> 3.9'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-sidekiq', '~> 0.20.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_job_status', '~> 1.2.1'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'devise_ldap_authenticatable'
gem 'handle-system', '0.1.1'
gem 'ladle'
gem 'mysql2'
gem 'react-rails'
gem 'redis-activesupport', '~> 5.0.4'
gem 'redis-rails' # Will install several other redis-* gems
gem 'rsolr', '>= 1.0'
gem 'sanitize', '~> 4.6', '>= 4.6.3'
gem 'sidekiq'

group :development, :test do
  gem 'bixby'
  gem 'capybara'
  gem 'capybara-maleficent', require: false
  gem 'capybara-screenshot'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'fcrepo_wrapper'
  gem 'ffaker'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'solr_wrapper', '>= 0.3'
end
