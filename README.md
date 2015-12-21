[![Build Status](https://travis-ci.org/renuo/renuo-cms-api.svg?branch=master)](https://travis-ci.org/renuo/renuo-cms-api) [![Build Status](https://travis-ci.org/renuo/renuo-cms-api.svg?branch=develop)](https://travis-ci.org/renuo/renuo-cms-api) [![Code Climate](https://codeclimate.com/github/renuo/renuo-cms-api/badges/gpa.svg)](https://codeclimate.com/github/renuo/renuo-cms-api) [![Test Coverage](https://codeclimate.com/github/renuo/renuo-cms-api/badges/coverage.svg)](https://codeclimate.com/github/renuo/renuo-cms-api/coverage) [![Issue Count](https://codeclimate.com/github/renuo/renuo-cms-api/badges/issue_count.svg)](https://codeclimate.com/github/renuo/renuo-cms-api)

# Renuo CMS API

The backend of the [Renuo](https://www.renuo.ch) CMS.

Documented here https://renuo.gitbooks.io/renuo-cms-doc/content/

## API Documentation

http://petstore.swagger.io/?url=https://renuo-cms-api-develop.herokuapp.com/swagger.yml

See doc/README.md to see how to edit the documentation.

## Domains

### Master

[![Build Status](https://travis-ci.org/renuo/renuo-cms-api.svg?branch=master)](https://travis-ci.org/renuo/renuo-cms-api)

https://renuo-cms-api-master.herokuapp.com

### Develop

[![Build Status](https://travis-ci.org/renuo/renuo-cms-api.svg?branch=develop)](https://travis-ci.org/renuo/renuo-cms-api)

https://renuo-cms-api-develop.herokuapp.com

### Testing

[![Build Status](https://travis-ci.org/renuo/renuo-cms-api.svg?branch=testing)](https://travis-ci.org/renuo/renuo-cms-api)

https://renuo-cms-api-testing.herokuapp.com

## Installation

```sh
git clone git@github.com:renuo/renuo-cms-api.git
cd renuo-cms-api
bin/setup
```

### Configuration

```sh
bin/setup
```

* config/database.yml
* config/application.yml

## Rake Tasks

Delete all content blocks: 

```sh
rake renuo_cms_api:delete_content_blocks
```

## Tests / Code Linting / Vulnerability Check

### Everything

```sh
bin/check
```

This runs

* rspec
* rubocop
* brakeman

### Rspec Only

```sh
rspec
```

### CI & Code Quality

* https://travis-ci.org/renuo/renuo-cms-api
* https://codeclimate.com/github/renuo/renuo-cms-api


## Server

```sh
rails s -b renuo-cms-api.dev
```

## Copyright

Coypright 2015 [Renuo GmbH](https://www.renuo.ch/).
