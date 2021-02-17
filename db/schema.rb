# typed: strict
# frozen_string_literal: true

DB.conn.execute <<-SQL
  DROP TABLE IF EXISTS products;
SQL

DB.conn.execute <<-SQL
  CREATE TABLE products(
    product_id INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    is_anchor  BOOLEAN NOT NULL
  );
SQL

DB.conn.execute <<-SQL
  DROP TABLE IF EXISTS rules;
SQL

DB.conn.execute <<-SQL
  CREATE TABLE rules(
    rule_id               INTEGER PRIMARY KEY,
    configured_product_id INTEGER NOT NULL,
    optional_product_id   INTEGER NOT NULL,
    quantity_constraint   TEXT,
    FOREIGN KEY(configured_product_id) REFERENCES products(product_id),
    FOREIGN KEY(optional_product_id)   REFERENCES products(product_id)
  );
SQL

DB.conn.execute <<-SQL
  DROP TABLE IF EXISTS subscriptions;
SQL

DB.conn.execute <<-SQL
    CREATE TABLE subscriptions(
      subscription_id INTEGER PRIMARY KEY,
      starts_at       INTEGER NOT NULL,
      ends_at         INTEGER NOT NULL
    )
SQL

DB.conn.execute <<-SQL
    DROP TABLE IF EXISTS skus;
SQL

DB.conn.execute <<-SQL
  CREATE TABLE skus(
    sku_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    subscription_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY(product_id) REFERENCES products(product_id),
    FOREIGN KEY(subscription_id) REFERENCES subscriptions(subscription_id)
  );
SQL
