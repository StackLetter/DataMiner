source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'

gem 'rollbar'

gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sidekiq-cron'
gem 'sidekiq-uniq'
gem 'redis', '~> 3.0'

gem 'rest-client'
gem 'graphql'

gem 'htmlentities'

gem 'figaro'

gem 'descriptive_statistics'

gem 'uglifier', '>= 1.3.0'
gem 'execjs'
gem 'therubyracer'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
