# Mantra

Yet another simple Ruby application to learn more about
[Sorbet](https://sorbet.org/)

## Development

For convenience, a `Dockerfile` and `docker-compose.yml` are provided. Simply
execute the following to open an Interactive Ruby (IRB) REPL.

```sh
# Build the docker image
docker-compose build

# Create the database schema (only do that once)
docker-compose run --rm app bin/reset_db

# Open a console
docker-compose run --rm app bin/console
```

## Tests

Unit tests are leveraging [RSpec](https://rspec.info/), code linting is done
with [RuboCop](https://rubocop.org/), and type checking is provided by
[Sorbet](sorbet.org/).

Simply execute the following the run the test suite.

```sh
# Unit tests and code linting
docker-compose run --rm test rake

# Type checking
docker-compose run --rm test srb tc
```
