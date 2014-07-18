require "bundler/gem_tasks"
require 'bundler/setup'
require 'mailer/model'

desc "prepare db"
task :create_db do
  Mailer::Model.connection.execute <<-SQL
CREATE TABLE IF NOT EXISTS mailers (
    id int PRIMARY KEY,
    name varchar(200) NOT NULL,
    age  int NOT NULL,
    email varchar(200) UNIQUE
);
SQL
  Mailer::Model.connection.execute <<-SQL
CREATE UNIQUE INDEX IF NOT EXISTS UniqueEmail ON mailers (email);
SQL
end



