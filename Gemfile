# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.2'

gem 'bootsnap'

gem 'rack-attack'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'figaro'

gem 'oj'

# Devise authentication
gem 'devise'
gem 'doorkeeper'

gem 'cancancan'

# GraphQL
gem 'graphql'

gem 'ar_lazy_preload'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'date_validator'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'byebug', platform: :mri

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'rspec-graphql_matchers'
  gem 'rspec-graphql_response'
  gem 'rspec-rails'

  gem 'annotate', require: false
  gem 'bullet'
  gem 'rails-erd'
end

group :test do
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'graphiql-rails'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
