# typed: strict
# frozen_string_literal: true

class ProductRepository
  extend T::Sig

  QUERY_ALL  = 'SELECT product_id, name FROM products'
  FIND_BY_ID = 'SELECT product_id, name FROM products WHERE product_id = ?'

  sig { returns(T::Array[Product]) }
  def all
    DB.conn.execute(QUERY_ALL).map do |row|
      Product.new(id: row[0], name: row[1])
    end
  end

  sig { params(id: Integer).returns(T.nilable(Product)) }
  def find(id)
    rows = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil if rows.empty?

    Product.new(id: rows.dig(0, 0), name: rows.dig(0, 1))
  end
end
