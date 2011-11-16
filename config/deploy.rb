namespace :deploy do
	desc "Running Bundler" do
		run "cd /opt/jantire && bundle install"
	end

	desc 'Compiling Assets'
	task :compile_assets  do
		run "cd /opt/jantire/ && bundle exec rake assets:precompile RAILS_ENV=production"
	end

	desc "Loading Database Schema"
	task :load_db_schema  do
		run "cd /opt/jantire/ && bundle exec rake db:schema:load"
	end

	desc "Restarting Server"
	task :restart_server  do
		run "cd /opt/jantire && touch tmp/restart.txt"
	end

end