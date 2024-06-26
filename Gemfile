source 'https://rubygems.org'
ruby "2.7.2"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '>= 5.6.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'bootstrap-sass', '3.4.1'
# This brings back 'assigns' and 'assert_template' to tests:
gem 'rails-controller-testing'
# Devise for login and authenticating
gem 'devise', '>= 4.7.1'

# Rolify for easy assignment and querries of roles
gem 'rolify'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# This is required for ActiveAdmin
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin'

# ActiveStorage solution for file attachment required the following:
# gem 'aws-sdk-s3', require: false
gem 'aws-sdk', '~> 3', require: false
gem 'image_processing', '~> 1.12.2'
gem 'active_storage_validations'
# This is a dependency of AWS, but for security reasons I had to bump its version:
gem 'jmespath', '~> 1.6.1'

# Pagination support used in ticket admin view:
# gem 'will_paginate'
# gem 'bootstrap-will_paginate'
gem 'kaminari'
gem 'kaminari-bootstrap3'

gem 'barby'
gem 'rqrcode'



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'awesome_print'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
