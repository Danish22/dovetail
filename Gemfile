source 'https://rubygems.org'

ruby "2.1.5"

gem 'rails', '4.1.1'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml'
gem 'simple_form'
gem 'country_select'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# -- DO NOT USE THE RUBY RACER, Install NodeJS and make sure it's in the path

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'devise'
gem 'invoicing'
gem 'gravtastic'
gem "figaro"
gem 'whenever', :require => false
gem 'minitest'
gem 'rb-readline'
gem "haml-rails"

gem 'kaminari'
gem 'bootstrap_form'
gem 'textacular', '~> 3.0'
gem 'money'

gem 'evil_icons'

# For stripe and/or OAuth 2.0
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'oauth2'

gem 'activeadmin', github: 'gregbell/active_admin'
gem "jquery-ui-rails", '~> 5.0'

gem 'rails_12factor', group: :production

gem 'uuid', '~> 2.3.7'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem "omniauth" 
gem "omniauth-identity"

gem 'friendly_id', '~> 5.0.0' # Note: You MUST use >= 5.0.0 for Rails 4.0+

gem 'rufus-scheduler'

group :development, :test do
  gem 'meta_request'
  gem 'pry'
  gem "better_errors"
  gem "binding_of_caller"
  gem "mailcatcher"

  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'capistrano-postgresql', '~> 4.2.0'
end

# Spring speeds up development by keeping your application
#  running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use unicorn as the app server
gem 'unicorn'
