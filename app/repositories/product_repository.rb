# typed: strict
# frozen_string_literal: true

class ProductRepository
  extend T::Sig

  FIELDS = T.let(%w[product_id name is_anchor].freeze, T::Array[String])

  QUERY_ALL  = T.let("SELECT #{FIELDS.join(',')} FROM products", String)
  FIND_BY_ID = T.let("SELECT #{FIELDS.join(',')} FROM products WHERE product_id = ?", String)
  INSERT     = 'INSERT INTO products (name, is_anchor) VALUES (?, ?)'
  UPDATE     = 'UPDATE products SET name = ?, is_anchor = ? WHERE product_id = ?'
  DELETE     = 'DELETE FROM products WHERE product_id = ?'

  sig { returns(T::Array[Product]) }
  def all
    DB.conn.execute(QUERY_ALL).map do |row|
      product_from_row(row)
    end
  end

  sig { params(id: Integer).returns(T.nilable(Product)) }
  def find(id)
    row = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil unless row

    product_from_row(row)
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

  sig { params(row: SQLite3::ResultSet::ArrayWithTypesAndFields).returns(Product) }
  def product_from_row(row)
    is_anchor = row[2] == 1
    Product.new(id: row[0], name: row[1], anchor: is_anchor)
  end

  sig { params(product: Product).returns(Product) }
  def insert(product)
    is_anchor = product.anchor? ? 1 : 0
    DB.conn.execute(INSERT, product.name, is_anchor)

    product.tap do |p|
      p.instance_variable_set(:@id, DB.conn.last_insert_row_id)
    end
  end

  sig { params(product: Product).returns(Product) }
  def update(product)
    is_anchor = product.anchor? ? 1 : 0
    DB.conn.execute(UPDATE, product.name, is_anchor, product.id)
    product
  end
end
