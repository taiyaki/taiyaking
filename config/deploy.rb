load "deploy/assets"

set :application, "taiyaking"
set :repository,  "git://github.com/taiyaki/taiyaking.git"

set :scm, :git

set :user, :taiyaki
set :use_sudo, false

set :deploy_to, "/home/#{user}/#{application}"
set :repository_cache, "master"
set :deploy_via, :remote_cache
set :rake, ENV["RAKE"]

role :web, "taiyaki.ru"                          # Your HTTP server, Apache/etc
role :app, "taiyaki.ru"                          # This may be the same as your `Web` server
role :db,  "taiyaki.ru", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:setup" do
  config_path = File.join(shared_path, "config")
  db_path = File.join(shared_path, "db")
  paths = [config_path, db_path]
  run("#{try_sudo} mkdir -p #{paths.join(' ')} && " +
      "#{try_sudo} chmod g+w #{paths.join(' ')}")
  run("#{try_sudo} sqlite3 #{db_path}/production.sqlite3 .quit")
  top.upload("config/database.yml.production",
             File.join(config_path, "database.yml"))
  smtp_yml = "config/smtp.yml.production"
  if File.exist?(smtp_yml)
    top.upload(smtp_yml, File.join(config_path, "smtp.yml"))
  end

  session_secret_file = "config/session_secret.txt"
  unless File.exist?(session_secret_file)
    require 'active_support'
    File.open(session_secret_file, "w") do |file|
      file.puts(ActiveSupport::SecureRandom.hex(64))
    end
    top.upload(session_secret_file, File.join(config_path, "session_secret.txt"))
  end

  google_analytics_code_txt = "config/google-analytics-code.txt.production"
  if File.exist?(google_analytics_code_txt)
    top.upload(google_analytics_code_txt,
               File.join(config_path, "google-analytics-code.txt"))
  end
end

# after "deploy:update_code" do
#   rake = fetch(:rake, "rake")
#   rails_env = fetch(:rails_env, "production")
#   run "cd #{latest_release}; #{rake} RAILS_ENV=#{rails_env} gettext:mo:create"
# end

after "deploy:finalize_update" do
  database_yml = "#{latest_release}/config/database.yml"
  shared_smtp_yml = "#{shared_path}/config/smtp.yml"
  smtp_yml = "#{latest_release}/config/smtp.yml"
  run "rm -f #{database_yml}"
  run "ln -s #{shared_path}/config/database.yml #{database_yml}"
  run "[ -f #{shared_smtp_yml} ] && ln -s #{shared_smtp_yml} #{smtp_yml}"
  run "ln -s #{shared_path}/config/session_secret.txt #{latest_release}/config/"

  run "ln -s #{shared_path}/db/production.sqlite3 #{latest_release}/db/"

  google_analytics_code_txt = "#{shared_path}/config/google-analytics-code.txt"
  run("[ -f #{google_analytics_code_txt} ] && " +
      "ln -s #{google_analytics_code_txt} #{latest_release}/config/")
end
