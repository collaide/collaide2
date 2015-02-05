namespace :db do
  desc 'Raise an error unless development environment'
  task :dev_only do
    raise 'You can only use this in dev!' unless Rails.env == 'development'
  end

  desc 'Drop, create, migrate the development database'
  task recreate: %w(environment db:dev_only db:drop db:create db:migrate db:test:prepare)
end