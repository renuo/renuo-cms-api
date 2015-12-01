# Renuo CMS API

The soon-to-be central CMS of [Renuo](https://www.renuo.ch). Is a work in progress.

## API Documentation

See doc/README.md.

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
bin/setup
```

### Configuration

Copy the database and application example-config files and fill out the missing values.
Password and API-keys can be found in the Redmine Wiki.

* config/database.yml
* config/application.yml

```sh
bin/setup
```

## Database

```sh
bin/setup
```

## Tests / Code Linting / Vulnerability Check

### Everything

```sh
bin/check
```

This runs

* rspec
* rubocop
* breakman

### Rspec Only

```sh
rspec
```

### Mutant Testing

Need to be enabled. Run

```sh
MUTANT=1 bin/check
```

for instructions.

### CI

https://ci.renuo.ch/projects/38


## Server

```sh
rails s -b renuo-cms-api.dev
```

## Main Contributors

![Nicolas Eckhart](https://www.gravatar.com/avatar/742cec893c283daf4a3c287ef2681599) ![Lukas Elmer](https://www.gravatar.com/avatar/697b8e2d3bde4d895eca4fe2dcfe9239.jpg)

## Copyright

Coypright 2015 [Renuo GmbH](https://www.renuo.ch/).
