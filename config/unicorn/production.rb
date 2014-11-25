root = "/home/deploy/dovetailv2/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
 
# Port configuration
listen "127.0.0.1:5200"
worker_processes 4
timeout 30
 
# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end
