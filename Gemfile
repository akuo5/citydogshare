source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails', '~> 4.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'omniauth-facebook'
gem 'railroady'
gem 'rake'
gem 'jquery-rails'
gem 'rails_secret_token_env'
gem 'geocoder'

gem "paperclip"
gem 'aws-sdk'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'jasmine-rails'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'autotest-rails'
  gem 'simplecov', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'factory_girl_rails'
  gem 'metric_fu'
  gem 'minitest'
  #gem 'rmagick'
end

group :test do
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil

end

group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'sass'
  gem 'coffee-rails'
  gem 'semantic-ui-sass', github: 'doabit/semantic-ui-sass', branch: 'v1.0beta'
  gem 'fullcalendar-rails'
  gem 'momentjs-rails'


  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'