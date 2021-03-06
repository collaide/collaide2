source 'https://rubygems.org'

#ruby '2.1.3' # For heroku

gem 'rails', '4.2.0'

# CSS + JavaSscript
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

# JavaScript library
gem 'jquery-rails', '~> 4.0.3'
gem 'ui_datepicker-rails3', '~> 1.2.0'
gem 'angular-rails-templates'

# JSON
gem 'jbuilder', '~> 2.0'

# DataBases
gem 'pg', '~> 0.17.1'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# HTML
gem 'foundation-rails', '~> 5.5.0.0'
gem 'foundation-icons-sass-rails', '~> 3.0.0'
gem 'haml', '~> 4.0.6'

# I18n
gem 'rails-i18n', '~> 4.0.0'
gem 'i18n', '~> 0.7.0'
gem 'route_translator', '~> 4.0.0'

#Formular
gem 'simple_form', '~> 3.1.0'
gem 'select2-rails', '~> 3.5.9.1' # séléction multiple

#User
gem 'devise', '~> 3.4.1'
gem 'devise-i18n-views', '~> 0.3.3'
gem 'geocoder', '~> 1.2.6'
# Social networks authentication
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-facebook', '~> 2.0.0'
gem 'omniauth-google-oauth2', '~> 0.2.6'

#Helper gems
gem 'enumerize', '~> 0.9.0' # Enumration dans les modèles
gem 'carrierwave', '~> 0.10.0' # Upload de fichier facilité
gem 'mini_magick', '~> 4.0.2' # Redimmensionnement d'image
gem 'kaminari', '~> 0.16.2' # Pagination
# gem 'sanitize', '~> 3.1.0' # Escape les éléments HTML sauf ceux spécifiés

#Tinymce (html editor)
gem 'tinymce-rails', '~> 4.1.6'
gem 'tinymce-rails-langs', '~> 4.20140129'

gem 'angularjs-rails', '~> 1.3.10' # Front-end javascript

#gem 'rack-canonical-host', '~> 0.1.0' # For redirecting to beta.collaide.com

# Gems for the group module
gem 'repository-manager', '~> 0.2.11'

gem 'puma'

gem 'figaro'

group :development, :test do

  gem 'byebug', '~> 3.5.1' # Debugger

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'sqlite3', '~> 1.3.10'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.2.0'

  gem 'quiet_assets', '>= 1.0.1' # messages de logs plus lisibles

  gem 'cucumber-rails', '~> 1.4.2', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner', '~> 1.4.0'
  gem 'rspec-expectations', '~> 3.2.0'
  gem 'rspec-rails', '~> 3.2.0'
  gem 'selenium-webdriver', '~> 2.44.0'

  gem 'factory_girl', '~> 4.5.0'
  gem 'factory_girl_rails', '~> 4.5.0'

  gem 'meta_request' # Pour le railsPanel sous chrome

  gem 'faker', '~> 1.4.3' # populate with fake datas

  gem 'bower-rails', '~> 0.9.2' # manage assets (javascript) more easily
end

group :production do
  gem 'carrierwave-aws', '~> 0.5.0'
  gem 'rails_12factor'
end
