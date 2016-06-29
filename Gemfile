source "https://rubygems.org"

ruby "2.2.3"
gem "rails", "4.2.4"

gem "rails-api"
gem "coveralls", require: false
gem "spring", group: :development
gem "responders", "~> 2.0"
gem "jwt"
gem "figaro", "~> 1.0.0"
# To use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"
gem 'rack-cors', :require => 'rack/cors'
# To use Jbuilder templates for JSON
# gem "jbuilder"
gem "active_model_serializers"
# Use unicorn as the app server
# gem "unicorn"

# Deploy with Capistrano
# gem "capistrano", :group => :development

# To use debugger
# gem "ruby-debug19", :require => "ruby-debug"
group :development, :test do
  gem "codeclimate-test-reporter"
  gem "byebug"
  gem "pry"
end
group :development do
  gem "sqlite3"
end
group :production do
  gem "pg"
  gem "rails_12factor"
end
