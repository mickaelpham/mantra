# typed: strict
# frozen_string_literal: true

DB.conn.execute <<-SQL
  DROP TABLE IF EXISTS products;
SQL

DB.conn.execute <<-SQL
  CREATE TABLE products(
    product_id INTEGER PRIMARY KEY,
    name       VARCHAR(100) NOT NULL
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
    quantity_constraint   VARCHAR(20),
    FOREIGN KEY(configured_product_id) REFERENCES products(product_id),
    FOREIGN KEY(optional_product_id)   REFERENCES products(product_id)
  );
SQL