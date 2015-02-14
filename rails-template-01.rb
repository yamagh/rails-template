# Rails Version Check
unless `rails -v`.include?("Rails 4.2")
  if no? 'This template if for rails 4.2. continue?'
    exit
  end
end

# ####################
# ======= Gems =======
# --------------------

gem 'twitter-bootswatch-rails', '3.2.0.0'
gem 'twitter-bootswatch-rails-helpers', '3.2.0.0'
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


# ####################
# ==== Initialize ====
# --------------------

# RSpec
run 'rails g rspec:install'

# Spring
run 'spring binstub --all'

# Guard
run 'guard init'
puts <<-EOS
Please edit Guardfile
==========================================================================
- guard :rspec, cmd: "bundle exec rspec" do
+ guard :rspec, cmd: "bin/rspec" do
==========================================================================
EOS

# git
git :init

