# typed: false
# frozen_string_literal: true

class ProductRepository
  extend Forwardable
  extend T::Sig

  QUERY_ALL  = 'SELECT product_id, name FROM products'
  FIND_BY_ID = 'SELECT product_id, name FROM products WHERE product_id = ?'

  def all
    execute(QUERY_ALL).map do |row|
      Product.new(id: row[0], name: row[1])
    end
  end

  def find(id)
    rows = get_first_row(FIND_BY_ID, id)
    return nil if rows.empty?

    Product.new(id: rows.dig(0, 0), name: rows.dig(0, 1))
  end

  def_delegator :DB, :conn
  def_delegator :conn, :execute, :get_first_row
end
