namespace :db do
  desc 'Create default data'
  task :seed do
    `ruby db/seed.rb`
  end # seed
end # namespace :db
