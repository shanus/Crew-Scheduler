set :use_sudo, true
set :application, "scheduler"
set :svn, "/usr/local/bin/svn"
set :repository,  "http://www.infobridge.net/svn/scheduler"
set :svn_username, "shaun"
set :svn_password, "last1out"
set :scm_username, "shaun"
set :scm_password, "last1out"
set :keep_releases, 3

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/Library/WebServer/#{application}"

# mongrel cluster items
require 'mongrel_cluster/recipes'
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"


# remove .svn folders
set :deploy_via, :export

role :app, "scheduler.yarmouth-rowing.org"
role :web, "scheduler.yarmouth-rowing.org"
role :db,  "scheduler.yarmouth-rowing.org", :primary => true

task :disable_web, :roles => :web do
  
  require 'erb'
  
  set :deadline, ENV['UNTIL']
  set :reason, ENV['REASON']
  template = File.read("./app/views/layouts/maintenance.html.erb")
  
  on_rollback { delete "#{shared_path}/system/maintenance.html" }
  
  maintenance = ERB.new(template).result(binding)
                       
  put maintenance, "#{shared_path}/system/maintenance.html", 
                   :mode => 0644
end

task :enable_web, :roles => :web do
  run "rm #{shared_path}/system/maintenance.html"
end

# namespace :deploy do
#   namespace :mongrel do
#     [ :stop, :start, :restart ].each do |t|
#       desc "#{t.to_s.capitalize} the mongrel appserver"
#       task t, :roles => :app do
#         #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
#         invoke_command "mongrel_rails cluster::#{t.to_s}", :via => run_method
#       end
#     end
#   end
# 
#   desc "Custom restart task for mongrel cluster"
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     deploy.mongrel.restart
#   end
# 
#   desc "Custom start task for mongrel cluster"
#   task :start, :roles => :app do
#     deploy.mongrel.start
#   end
# 
#   desc "Custom stop task for mongrel cluster"
#   task :stop, :roles => :app do
#     deploy.mongrel.stop
#   end

end