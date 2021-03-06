# Rails Version Check
unless `rails -v`.include?("Rails 4.2")
  if no? 'This template if for rails 4.2. continue?'
    exit
  end
end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# ####################
# ======= Gems =======
# --------------------

gem 'twitter-bootswatch-rails'
gem 'twitter-bootswatch-rails-helpers'
gem 'therubyracer'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'guard-livereload', require: false
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'slim-rails'
  gem 'html2slim'
end

run_bundle

# ####################
# ==== Initialize ====
# --------------------

# RSpec #######################################################################

generate 'rspec:install'
run 'rm spec/rails_helper.rb'
copy_file 'templates/rails_helper.rb', 'spec/rails_helper.rb'

# Spring ######################################################################

run 'spring binstub --all'

# Guard #######################################################################

run 'guard init'
run 'sed -i "" "s;bundle exec rspec;bin/rspec;g" Guardfile'

# LiveReload ##################################################################


# BootSwatch ##################################################################

run 'spring stop'
theme = 'simplex'
generate "bootswatch:install #{theme} --force"
generate "bootswatch:import #{theme} --force"
generate "bootswatch:layout #{theme} --force"

css =<<EOF
/*
 *= require #{theme}/loader
 *= require #{theme}/bootswatch
 */
EOF
run "echo '#{css}' >> app/assets/stylesheets/application.css"

js =<<EOF
//= require #{theme}/loader
//= require #{theme}/bootswatch
EOF
run "echo '#{js}' >> app/assets/javascripts/application.js"

run "echo 'Rails.application.config.assets.precompile += %w( #{theme}.css )' >> config/initializers/assets.rb"
run "echo 'Rails.application.config.assets.precompile += %w( #{theme}.js )'  >> config/initializers/assets.rb"

run 'rm app/views/layouts/application.html.erb'
run 'mv app/views/layouts/simplex.html.slim app/views/layouts/application.html.slim'

# git #########################################################################

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

# Comments ####################################################################

puts '========================================'
puts 'Add variable like below'
puts 'This fix need until it will be fixed.'
puts ''
puts "echo '@zindex-modal-background: 0;' >> app/assets/stylesheets/#{theme}/variables.less"
puts '========================================'

