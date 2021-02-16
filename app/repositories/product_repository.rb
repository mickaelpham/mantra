# typed: strict
# frozen_string_literal: true

class ProductRepository
  extend T::Sig

  QUERY_ALL  = 'SELECT product_id, name FROM products'
  FIND_BY_ID = 'SELECT product_id, name FROM products WHERE product_id = ?'
  INSERT     = 'INSERT INTO products (name) VALUES (?)'
  UPDATE     = 'UPDATE products SET name = ? WHERE product_id = ?'
  DELETE     = 'DELETE FROM products WHERE product_id = ?'

  sig { returns(T::Array[Product]) }
  def all
    DB.conn.execute(QUERY_ALL).map do |row|
      Product.new(id: row[0], name: row[1])
    end
  end

  sig { params(id: Integer).returns(T.nilable(Product)) }
  def find(id)
    row = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil if row.empty?

    Product.new(id: row[0], name: row[1])
  end

  sig { params(product: Product).returns(Product) }
  def save(product)
    product.id ? update(product) : insert(product)
  end

  sig { params(id: Integer).returns(Integer) }
  def delete(id)
    DB.conn.execute(DELETE, id)
    DB.conn.changes
  end

  private

  sig { params(product: Product).returns(Product) }
  def insert(product)
    DB.conn.execute(INSERT, product.name)

    product.tap do |p|
      p.instance_variable_set(:@id, DB.conn.last_insert_row_id)
    end
  end

  sig { params(product: Product).returns(Product) }
  def update(product)
    DB.conn.execute(UPDATE, product.name, product.id)
    product
  end
end
