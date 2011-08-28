require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Derek Keller",
                          :email => "derek@gmail.com",
                          :password => "derek",
                          :admin => true)
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "boring"
      User.create!(:name => name, :email => email, :password => password)
    end
  end
end