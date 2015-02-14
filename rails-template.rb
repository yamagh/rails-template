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
copy_file 'templates/rails_helper.rb', 'spec/rails_helper.rb'

# Spring
run 'spring binstub --all'

# Guard
run 'guard init'
run 'sed -i "" "s;bundle exec rspec;bin/rspec;g" Guardfile'

# git
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

