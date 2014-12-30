#! /bin/bash

# This script is intended to be run on a vagrant virtual machine.

# Create the database user and database for use by Dovetail.
sudo -u postgres createuser --createdb vagrant

# Update rbenv
cd ~/.rbenv && git pull

# Update ruby-build
cd ~/.rbenv/plugins/ruby-build && git pull

# Install ruby 2.1.5
rbenv install 2.1.5

# Set the default ruby version
rbenv global 2.1.5

# Core/Base gems
gem install bundler --no-ri --no-rdoc
gem install mailcatcher --no-ri --no-rdoc

# Install upstart script for mailcather
sudo cp /vagrant/mailcatcher.conf /etc/init

# Start it up first time - it will run automatically on subsequent boots
sudo service mailcatcher start

# Install the app's libraries
cd /vagrant && bundle install

# The default sample database config Just Works(tm)
#
#   ** Note will overwrite any existing database configuration file on the host side ** 
#
cp /vagrant/config/database-sample.yml /vagrant/config/database.yml

# Create the databases (Dev, test and prod)
cd /vagrant && bundle exec rake db:create

# Run the migrations to bring the schema upto date
cd /vagrant && bundle exec rake db:migrate
