# $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.

require 'bundler/capistrano'
require './config/boot'
#require 'airbrake/capistrano'

require 'whenever/capistrano'
set :whenever_command, "bundle exec whenever"

set :user, "deploy"

set :default_environment, {
  'PATH' => "/usr/local/bin:/bin:/usr/bin:/bin:/home/deploy/.rbenv/shims",
}

ssh_options[:forward_agent] = true  # Use ssh-agent (via ssh-add) for your key to github.
default_run_options[:pty] = true

set :application, "dovetailv2"
set :repository,  "git@bitbucket.org:dovetail/appv2.git"

set :scm, :git
set :branch, "master"

#Set the full path to your application on the server
set :deploy_to, "/home/depoy/#{application}/"

role :app, "app.dovetail.io"
role :web,"app.dovetail.io"
role :db,  "app.dovetail.io", :primary => true
set :unicorn_port, 5200

set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

after("deploy:update_code") do
  run "ln -nfs #{shared_path}/config/* #{release_path}/config/"
end

load 'deploy/assets'  # For rails 3.1 (asset pipeline_

namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E production -p #{unicorn_port} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
