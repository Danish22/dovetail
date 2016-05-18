# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'dovetailv2'
set :repo_url, 'git@bitbucket.org:dovetail/app-v2.git'

set :stages, %w(production)
set :default_stage, "production"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.5'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :ssh_options, {
  forward_agent: true,
}

set :deploy_to, '/home/deploy/dovetailv2'

# Default value for :linked_files is []
set :bundle_binstubs, nil
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
 
  desc 'Restart application'
  task :restart do
    # Reload unicorn with capistrano3-unicorn hook
    # needs to be before "on roles()"
    invoke 'unicorn:reload'
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
    end
  end
 
  after :finishing, 'deploy:cleanup'
  before :finishing, 'deploy:restart'
  after 'deploy:rollback', 'deploy:restart'
end
