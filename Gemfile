source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'redis'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'faraday', '0.15.1'
gem 'createsend'
gem 'sdoc'
gem 'redis-rails'
gem 'faker'
gem 'rubyzip'
gem "sentry-raven", git: 'https://github.com/mimolabs/raven-ruby.git'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot'
  gem 'faker'
  gem 'fakeredis'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.7'
  gem 'vcr'
  gem 'webmock'
end
