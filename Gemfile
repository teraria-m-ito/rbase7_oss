source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri mingw x64_mingw ]
  #  gem 'debase', '3.0.0.beta7'
  gem 'debase', '~> 0.2.5.beta2', require: false
  gem 'debase-ruby_core_source', '3.2.2'
  gem 'rubocop', require: false
  gem 'ruby-debug-ide', '0.7.3'
  gem 'executable-hooks', '1.6.1'
  gem 'foreman'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :deployment do
  gem 'capistrano', '>= 3.17.0'
  gem 'capistrano-bundler', '>= 2.1.0'
  gem 'capistrano-rails'
  gem 'capistrano-delayed-job'
  # gem 'rvm-capistrano'
  gem 'sshkit'
  # net-ssh が ssh-ed25519 鍵を使うために必要（https://github.com/net-ssh/net-ssh/issues/565）
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end

# gem 'reline', '0.3.0'
gem 'request_store'
gem 'activerecord-session_store'

gem 'rubyzip', '1.1.0'

gem 'devise', "~> 4.9.2"

gem 'simple_form'

gem 'selectable_attr', '0.3.18.rails7', git: 'https://github.com/minoruito/selectable_attr.git'
gem 'selectable_attr_rails', git: 'https://github.com/minoruito/selectable_attr_rails.git'

gem 'nested_form'

gem 'cancancan'

gem 'paranoia'
gem 'kaminari', '1.2.2.1.custom', git: 'https://github.com/minoruito/kaminari.git'

gem 'mime-types'
gem 'carrierwave'

gem 'thinreports'
gem 'thinreports-rails'

gem 'oauth'

gem 'jwt'
gem 'json-jwt'

gem "tinymce-rails"
gem 'tinymce-rails-langs'

gem 'axlsx'
gem 'zip-zip'
gem 'roo'

gem 'ancestry'

gem "bower-rails"
gem 'matrix'

gem "paper_trail"
gem 'grover', '1.1.9'

gem 'delayed_job_active_record'

gem "pg"
#gem 'activerecord7-redshift-adapter' , git: 'https://github.com/pennylane-hq/activerecord7-redshift-adapter.git'
gem 'activerecord7-redshift-adapter-pennylane', git: 'https://github.com/pennylane-hq/activerecord-adapter-redshift.git'
gem "attr_encrypted"

# gem "rack-timeout" #, require: "rack/timeout/base"

gem "sys-proctable"
gem 'userstamp', path: 'lib/immigration/userstamp'

gem 'rest-client'

# gem 'i18n', '< 1.9'

gem 'daemons'
gem 'sshkit-sudo'
gem 'ruby-saml'
gem 'dotenv-rails'
gem 'uri', '1.1.1'
gem 'saml_idp', path: 'lib/immigration/saml_idp'
gem 'cgi', '0.4.1'
# Ruby 3.1 同梱版と一致させる（bundled 0.3.0 だと先に load された 0.2.0 と Gem::LoadError になりやすい）
gem 'base64', '0.2.0'
gem 'logger', '1.6.0'
gem 'json', '2.7.2'
gem 'rack-cors', '2.0.2'
eval_gemfile File.join( File.dirname(__FILE__), "rbase_gems/Gemfile")

