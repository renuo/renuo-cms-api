# Renuo CMS API

The soon-to-be central CMS of Renuo LLC. Is a work in progress.

## Domains

### Master


### Develop


### Testing


## Ruby on Rails

This application requires:

- Ruby 2.2.0
- Rails 4.2

## Installation

```sh
git clone git@git.renuo.ch:renuo/renuo-cms-api.git
cd renuo-cms-api
bundle install
```

## Configuration

Copy the database and application example-config files and fill out the missing values.
Password and API-keys can be found in the Redmine Wiki.

```sh
cp config/database.example.yml config/database.yml
cp config/application.example.yml config/application.yml
```

## Database

Setup the database for the development environment:

```sh
bundle exec rake db:drop db:setup
```

## Tests

### Initialization

Setup the database for the test environment:

```sh
RAILS_ENV=test rake db:drop db:create db:migrate
```

### Run Tests

```sh
rspec
```

### CI



## Run

```sh
bundle exec rails s
```

## Problems?

Nicolas Eckhart is currently working on this application.

![Nicolas Eckhart](http://www.gravatar.com/avatar/742cec893c283daf4a3c287ef2681599)

## Copyright

Coypright 2015 [Renuo GmbH](https://www.renuo.ch/).
