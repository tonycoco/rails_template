# Rails Template

This is a Ruby on Rails template to get you going with Devise/RSpec/Cucumber/HAML and the Twitter Bootstrap. It provides some useful defaults, helpers and sets you up for a quick Heroku deployment with Amazon S3 support as well. It is meant to be a bootstrap to get an app off the ground quickly. It does not have options or support to turn features off. Maybe that will be added but, for now, if you don't need something that the template generates, just remove it.


## Useage

```
rails new APP_NAME -T -d mysql -m https://github.com/tonycoco/rails_template/raw/master/rails_template.rb
```


## Customization

Look for all instances of ```CHANGEME``` in the generated application and make sure you have these environment variables...

```
FACEBOOK_APP_ID
FACEBOOK_APP_SECRET
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

*Note: If you're using rbenv, check out [rbenv-vars](http://github.com/sstephenson/rbenv-vars.git).*

If you are customizing this template, you can use any methods provided by [Thor::Actions](http://rubydoc.info/github/wycats/thor/master/Thor/Actions) and [Rails::Generators::Actions](http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb)


## Workers

To start the ```UserWorker``` use the ```foreman``` gem...

```
bundle exec foreman start worker
```


## Notes

This template assumes you already have Rails and a basic understanding of building an application. If you'd like to help, just fork and send a pull-request!
