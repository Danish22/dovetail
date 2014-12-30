#! /bin/bash

# Update the app's libraries
cd /vagrant && bundle install

# Run the migrations to bring the schema upto date
cd /vagrant && bundle exec rake db:migrate
