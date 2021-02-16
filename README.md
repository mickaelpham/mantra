# Mantra

Yet another simple Ruby application to learn more about
[Sorbet](https://sorbet.org/)

## Usage

```rb
# add products to the catalog
product_repository = ProductRepository.new
products = {
  a: product_repository.save(Product.new name: 'Product A'),
  b: product_repository.save(Product.new name: 'Product B'),
  c: product_repository.save(Product.new name: 'Product C'),
}

# add rules
b_must_match_a = Rule.new(
  configured_product_id: products[:a].id,
  optional_product_id: products[:b].id,
  quantity_constraint: QuantityConstraint::WallToWall
)
c_must_be_lte_a = Rule.new(
  configured_product_id: products[:a].id,
  optional_product_id: products[:c].id,
  quantity_constraint: QuantityConstraint::LessThanOrEqual
)
rule_repository = RuleRepository.new
rules = {
  b_must_match_a: rule_repository.save(b_must_match_a),
  c_must_be_lte_a: rule_repository.save(c_must_be_lte_a)
}

# create an invalid subscription (qty of B is <= qty of A)
subscription_repository = SubscriptionRepository.new
subscription = subscription_repository.save(Subscription.new)

sku_repository = SKURepository.new
subscription_skus = {
  a: sku_repository.save(
    SKU.new(subscription_id: subscription.id, product_id: products[:a].id, quantity: 5)
  ),
  b: sku_repository.save(
    SKU.new(subscription_id: subscription.id, product_id: products[:b].id, quantity: 3)
  ),
  c: sku_repository.save(
    SKU.new(subscription_id: subscription.id, product_id: products[:c].id, quantity: 3)
  )
}

# verify that the subscription is not valid per our rules
subscription.compliant_with?(rule_repository.all)
# => false

# fix the improper SKU
subscription_skus[:b].quantity = 5
sku_repository.save(subscription_skus[:b])

# verify that the subscription is now valid per our rules
subscription.compliant_with?(rule_repository.all)
# => true

# make a change that invalidates the subscription again
subscription_skus[:c].quantity = 6
sku_repository.save(subscription_skus[:c])

# and verify that it is invalid with our rules
subscription.compliant_with?(rule_repository.all)
# => false
```

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
