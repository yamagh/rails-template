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
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rspec-rails'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'spring-commands-rspec'
end

run_bundle


# ####################
# ==== Initialize ====
# --------------------

# RSpec
generate 'rspec:install'
run 'rm spec/rails_helper.rb'
copy_file 'templates/rails_helper.rb', 'spec/rails_helper.rb'


# Spring
run 'spring binstub --all'


# Guard
run 'guard init'
run 'sed -i "" "s;bundle exec rspec;bin/rspec;g" Guardfile'


# BootSwatch
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
run 'mv app/views/layouts/simplex.html.erb app/views/layouts/application.html.erb'

# git
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

puts '========================================'
puts 'Add variable like below'
puts 'This fix need until it will be fixed.'
puts ''
puts "echo '@zindex-modal-background: 0;' >> app/assets/stylesheets/#{theme}/variables.less"
puts '========================================'

