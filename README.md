# Seo Tool
#### Sinatra app. Parses response by url and writes in file or database storage

## Install
Install gems `$ bundle install`

Set database parameters in `config/database.yml`

Set file storage parameters in `config/file_storage.yml`

Setup databases `$ rake db:setup`

Create demo data `$ rake db:seed`

## Usage
run `$ rackup` 

![Alt text](index_user.png?raw=true "User index page")
![Alt text](settings_user.png?raw=true "User settings page")
![Alt text](report_user.png?raw=true "User report page")
![Alt text](users_admin.png?raw=true "Admin users page")

`./bin/seo --help` will be shown all the teams and their description
![Alt text](command_line.png?raw=true "Command line interface")

Run tests `$ rspec spec`
