# Seo Tool
#### Sinatra app. Parses response by url and writes in file or database storage
Seo Tool on [Heroku] ()

## Install
Install gems
$ bundle install

set database parameters in 
config/database.yml

set file storage parameters in
config/file_storage.yml

setup databases
$ rake db:setup

create demo data
$ rake db:seed

## Usage
run `$ rackup` 
`./bin/seo --help` will be shown all the teams and their description
Run tests `$ rspec spec`

![Alt text](index_user.png?raw=true "User index page")
![Alt text](settings_user.png?raw=true "User settings page")
![Alt text](report_user.png?raw=true "User report page")
![Alt text](users_admin.png?raw=true "Admin users page")
![Alt text](command_line.png?raw=true "Command line interface")