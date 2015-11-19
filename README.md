# Renuo CMS API

The soon-to-be central CMS of Renuo LLC. Is a work in progress.

## Domains

### Master

https://renuo-cms-api-master.herokuapp.com

[![build status](https://ci.renuo.ch/projects/38/status.png?ref=master)](https://ci.renuo.ch/projects/38?ref=master)

### Develop

https://renuo-cms-api-develop.herokuapp.com

[![build status](https://ci.renuo.ch/projects/38/status.png?ref=develop)](https://ci.renuo.ch/projects/38?ref=develop)

### Testing

https://renuo-cms-api-testing.herokuapp.com

[![build status](https://ci.renuo.ch/projects/38/status.png?ref=testing)](https://ci.renuo.ch/projects/38?ref=testing)


## Installation

```sh
git clone git@git.renuo.ch:renuo/renuo-cms-api.git
cd renuo-cms-api
bundle install
ln -s ../../bin/check .git/hooks/pre-commit
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

### Run Tests

```sh
rspec
```

### CI

https://ci.renuo.ch/projects/38

### Code Linting / Vulnerability Check / Tests

Rubocop is used to lint the ruby code while Brakeman is used to check for security vulnerabilities.
They are both run in a pre-commit git hook to insure code quality. If you need to make changes to
the Rubocop configuration edit the .rubocop.yml file (configuration here: https://github.com/bbatsov/rubocop#configuration)

If you want to add other tools to the pre-commit hook, edit the script at .git/hooks/pre-commit.

If you want to run the tools manually, you can do so with the following command:

```sh
bin/check
```

If you want to enable mutant testing

```sh
MUTANT=1 bin/check
```

## Run

```sh
bundle exec rails s
```

## Problems?

Nicolas Eckhart is currently working on this application.

![Nicolas Eckhart](http://www.gravatar.com/avatar/742cec893c283daf4a3c287ef2681599)

## Copyright

Coypright 2015 [Renuo GmbH](https://www.renuo.ch/).
