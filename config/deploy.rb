require 'bundler/capistrano'

set :user, "ddstnkmp"
set :domain, "hartke.dreamhost.com"
set :project, "noblog"
set :application, "steinkamp.us"
set :applicationdir, "/home/#{user}/#{application}"
set :repository, "/home/#{user}/dev.steinkamp.us"
set :deploy_to, applicationdir
set :deploy_via, :export
set :use_sudo, :false
set :bundle_cmd, '/usr/lib/ruby/gems/1.8/bin/bundle'

set :scm, :git

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
