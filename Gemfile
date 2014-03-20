source 'https://rubygems.org'

group :test do
  gem 'bundler', '>= 1.5'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'sinatra'
  gem 'webmock'
  gem 'dotenv'
end

group :dev do
  gem 'guard', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'guard-rspec', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'guard-bundler', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'pry-rescue', :platforms => [:ruby_19, :ruby_20, :ruby_21]
end

gemspec
