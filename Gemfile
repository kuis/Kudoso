source 'http://rubygems.org'


# Core
gem 'rails', '4.1.6'
gem 'pg'

# View and Assets
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml'
gem 'haml-rails' # Provides HAML as the default generator
gem 'simple_form'
gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
gem 'font-awesome-rails'
gem 'jquery-turbolinks'
gem 'lazy_high_charts'
gem 'bourbon'
gem 'cocoon' # nested form helper
gem 'groupdate' # adds group_by_date functions
gem 'best_in_place' #adds in place editing features
gem 'kaminari'
gem 'modernizr-rails'
gem 'rails_layout', group: :development
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby



# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc


# User management
gem 'devise'
gem 'omniauth'
gem 'cancan'
gem 'chronic'
gem 'recurring_select' # for schedules

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'factory_girl_rails'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'rb-fsevent'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'parallel_tests'
  gem 'zeus-parallel_tests'
  gem 'binding_of_caller'
end

group :development do
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'better_errors'
  gem 'terminal-notifier-guard'
  gem 'habtm_generator'

  # Deployment
  gem 'capistrano'
end

group :test do
  gem 'launchy'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'zeus', :require => false
  gem 'shoulda-matchers'
  gem 'pdf-inspector'
  gem 'selenium-webdriver'
  gem 'faker'
  gem 'simplecov'
end

gem 'rubber'
gem 'open4'
