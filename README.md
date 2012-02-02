# Rails Template
This is a simple Ruby on Rails template to get you going with Devise/RSpec/Cucumber/HAML and the Twitter Bootstrap. It provides some useful defaults, helpers and sets you up for a quick Heroku deployment with Amazon S3 support as well.

## Useage
```
rails new APP_NAME -T -d mysql -m https://github.com/tonycoco/rails_template/raw/master/rails_template.rb
```

## Customization
Look for all instances of the string "CHANGEME" in the generated application and make sure you have the following setup on your system...

```
ENV['FACEBOOK_APP_ID']
ENV['FACEBOOK_APP_SECRET']
ENV['AWS_ACCESS_KEY_ID']
ENV['AWS_SECRET_ACCESS_KEY']
```

If you are customizing this template, you can use any methods provided by [Thor::Actions](http://rubydoc.info/github/wycats/thor/master/Thor/Actions) and [Rails::Generators::Actions](http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb)

## Notes
This is not yet finished. There has been continuous development on it. A 1.0.0 release will come soon.
