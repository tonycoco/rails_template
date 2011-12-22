# Application Generator Template
# Usage: rails new APP_NAME -T -m https://github.com/tonycoco/rails_template/raw/master/rails_template.rb
#
# If you are customizing this template, you can use any methods provided by Thor::Actions
# http://rubydoc.info/github/wycats/thor/master/Thor/Actions
# and Rails::Generators::Actions
# http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb

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
gem 'bootstrap_kaminari', :git => 'git://github.com/dleavitt/bootstrap_kaminari.git'
gem 'mini_magick'
gem 'settingslogic'

gem_group :development do
  gem 'capistrano'
  gem 'hpricot'
  gem 'ruby_parser'
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
inject_into_file 'app/helpers/application_helper.rb', :before => 'end' do <<-RUBY
  def yield_for(content_sym, default)
    content_yield = content_for(content_sym)
    content_yield.blank? ? default : content_yield
  end

  def body_css_classes
    c = []
    c << controller_name
    c << action_name
    c << yield_for(:body_class, nil)
    c
  end

  def alert_message_css_class_for(key)
    case key.to_sym
    when :alert
      return 'error'
    when :notice
      return 'success'
    else
      return key.to_s
    end
  end

  def alert_message_heading_for(key)
    case key.to_sym
    when :alert
      return I18n.t('alert_message.alert')
    when :notice
      return I18n.t('alert_message.notice')
    else
      return I18n.t('alert_message.default')
    end
  end

  def alert_message_for(flash, options={})
    except = options[:except]
    keys = flash.keys.select { |key| !key.match(except) } rescue []

    unless keys.blank?
      keys.each do |key|
        next if flash[key].blank?

        flash_text = content_tag(:p, content_tag(:strong, alert_message_heading_for(key)) + ' ' + flash[key])
        close_button = link_to('&times;'.html_safe, '#', :class => 'close')
        return content_tag(:div, (close_button + flash_text).html_safe, :class => "alert-message #{alert_message_css_class_for(key)}", :'data-alert' => 'alert')
      end
    end
  end
RUBY
end

#####################################################
# Locales
#####################################################
gsub_file 'config/locales/en.yml', /hello: "Hello world"/ do <<-YAML
  application:
    name: "Your Application"
    tagline: "Something witty here."
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
\n
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
run 'rails generate devise:views'
run 'for i in `find app/views/devise -name *.erb` ; do bundle exec html2haml -e $i ${i%erb}haml ; rm $i ; done'

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

inject_into_file 'app/controller/welcome_controller.rb', :before => 'end' do <<-RUBY
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

# TODO: Add avatar to User via Carrierwave
# TODO: Fix Devise's views
# TODO: Facebook Omniauth integration
