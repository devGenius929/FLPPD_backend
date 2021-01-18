source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'twilio-ruby'
gem 'simple_command'
gem 'active_hash_relation', github: 'kollegorna/active_hash_relation'
gem 'pundit', '~> 0.3.0'
gem 'jbuilder', '~> 2.5'
gem 'rack-cors'
gem "rmagick"
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'stripe' ##Gem Stripe for payments
gem 'dotenv-rails'
gem 'mailgun-ruby'
gem 'mailboxer'
gem 'geocoder'
# gem 'redis', '~> 3.0'
# gem 'capistrano-rails', group: :development

group :production do
  gem 'pg'
end
gem 'pg'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'sqlite3', '1.3.11'
end
gem 'listen', '~> 3.0.5'
gem 'awesome_print'
group :development do
  #deployment
  gem 'capistrano', '3.8.0', require: false
  gem 'capistrano-rbenv',   require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'awesome_print'

  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'fcm'
gem 'swagger-blocks'
gem 'swagger_engine', github: 'batdevis/swagger_engine'
gem 'sass-rails'
gem 'koala'