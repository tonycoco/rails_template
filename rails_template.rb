#####################################################
# Application Generator Template
# Usage: rails new APP_NAME -T -m https://raw.github.com/tonycoco/rails_template/master/rails_template.rb
#
# If you are customizing this template, you can use any methods provided by Thor::Actions
# http://rubydoc.info/github/wycats/thor/master/Thor/Actions
# and Rails::Generators::Actions
# http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb
#####################################################

#####################################################
# Gems
#####################################################
gem 'haml-rails'
gem 'kaminari'
gem 'omniauth'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'carrierwave'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :git => 'git://github.com/anjlab/bootstrap-rails.git'
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/stouset/twitter_bootstrap_form_for.git'
gem 'bootstrap_kaminari', :git => 'git://github.com/tonycoco/bootstrap_kaminari.git'
gem 'mini_magick'
gem 'settingslogic'

gem_group :development do
  gem 'capistrano'
  gem 'rails-footnotes'
  gem 'looksee'
  gem 'wirble'
  gem 'awesome_print'
  gem 'what_methods'
  gem 'ruby-debug19', :require => 'ruby-debug'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-rails'
  gem 'syntax'
  gem 'mysql2'
end

gem_group :production do
  gem 'pg'
  gem 'thin'
end

#####################################################
# Bundle
#####################################################
run 'bundle install'

#####################################################
# SettingsLogic
#####################################################
get 'https://raw.github.com/tonycoco/rails_template/master/files/settings_logic/config.yml', 'config/application.yml'
get 'https://raw.github.com/tonycoco/rails_template/master/files/settings_logic/model.rb', 'app/models/settings.rb'

#####################################################
# ApplicationHelper
#####################################################
get 'https://raw.github.com/tonycoco/rails_template/master/files/lib/bootstrap_helper.rb', 'app/helpers/bootstrap_helper.rb'

inject_into_file 'app/helpers/application_helper.rb', :before => 'end' do <<-RUBY
  include BootstrapHelper
RUBY
end

#####################################################
# Locales
#####################################################
gsub_file 'config/locales/en.yml', /hello: "Hello world"/ do <<-YAML
  application:
    name: "Your Application"
    slogan: "Something witty here."
  alert_message:
    default: "Heads up!"
    alert: "Oh snap!"
    notice: "Well done!"
YAML
end

#####################################################
# Application Layout
#####################################################
remove_file 'app/views/layouts/application.html.erb'
get 'https://raw.github.com/tonycoco/rails_template/master/files/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'
get 'https://raw.github.com/tonycoco/rails_template/master/files/views/shared/_topbar.html.haml', 'app/views/shared/_topbar.html.haml'

#####################################################
# Heroku
#####################################################
get 'https://raw.github.com/tonycoco/rails_template/master/files/heroku/Procfile', 'Procfile'

#####################################################
# RSpec
#####################################################
generate 'rspec:install'
run 'rm -rf test'

application do <<-RUBY
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.template_engine :haml
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

RUBY
end

inject_into_file 'spec/spec_helper.rb', :before => 'end' do <<-RUBY
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
RUBY
end

#####################################################
# Cucumber
#####################################################
generate 'cucumber:install --capybara --rspec'

#####################################################
# Devise
#####################################################
generate 'devise:install'
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
generate 'devise user'

inside 'app/views/devise' do
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/confirmation/new.html.haml', 'confirmation/new.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/mailer/confirmation_instructions.html.haml', 'mailer/confirmation_instructions.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/mailer/reset_password_instructions.html.haml', 'mailer/reset_password_instructions.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/mailer/unlock_instructions.html.haml', 'mailer/unlock_instructions.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/passwords/edit.html.haml', 'passwords/edit.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/passwords/new.html.haml', 'passwords/new.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/registrations/edit.html.haml', 'registrations/edit.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/registrations/new.html.haml', 'registrations/new.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/sessions/new.html.haml', 'sessions/new.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/shared/_links.html.haml', 'shared/_links.html.haml'
  get 'https://raw.github.com/tonycoco/rails_template/master/files/views/devise/unlocks/new.html.haml', 'unlocks/new.html.haml'
end

create_file 'spec/support/devise.rb' do <<-RUBY
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
RUBY
end

#####################################################
# Welcome
#####################################################
generate(:controller, 'welcome')

inject_into_file 'app/controllers/welcome_controller.rb', :before => 'end' do <<-RUBY
  before_filter :authenticate_user!
RUBY
end

route "root :to => 'welcome'"
get 'https://raw.github.com/tonycoco/rails_template/master/files/views/welcome/index.html.haml', 'app/views/welcome/index.html.haml'

#####################################################
# Clean-up
#####################################################
%w{
  README
  doc/README_FOR_APP
  public/index.html
  app/assets/images/rails.png
}.each { |file| remove_file file }

#####################################################
# Robots
#####################################################
gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'

#####################################################
# Carrierwave
#####################################################
get 'https://raw.github.com/tonycoco/rails_template/master/files/carrierwave/avatar_uploader.rb', 'app/uploaders/avatar_uploader.rb'
get 'https://raw.github.com/tonycoco/rails_template/master/files/carrierwave/avatar.png', 'app/assets/images/avatar.png'

# TODO: Facebook Omniauth integration
