require 'resque/tasks'

task 'resque:setup' => :environment do
  ENV['QUEUE'] = '*'
end

desc 'Alias for "resque:work" (Heroku)'
task 'jobs:work' => 'resque:work'
