# typed: true
# frozen_string_literal: true

class SKURepository
  extend T::Sig

  class TooManyIds < StandardError; end

  FIELDS = %w[sku_id product_id subscription_id quantity].freeze

  MAX_IDS      = 50
  UP_TO_2_IDS  = 2
  UP_TO_10_IDS = 10

  # See https://stackoverflow.com/a/189399
  FIND_BY_IDS = {
    UP_TO_2_IDS => "SELECT #{FIELDS.join(',')} FROM skus WHERE sku_id IN (#{Array.new(2, '?').join(',')})",
    UP_TO_10_IDS => "SELECT #{FIELDS.join(',')} FROM skus WHERE sku_id IN (#{Array.new(10, '?').join(',')})",
    MAX_IDS => "SELECT #{FIELDS.join(',')} FROM skus WHERE sku_id IN (#{Array.new(50, '?').join(',')})"
  }.freeze

  QUERY_ALL               = "SELECT #{FIELDS.join(',')} FROM skus"
  FIND_BY_ID              = "SELECT #{FIELDS.join(',')} FROM skus WHERE sku_id = ?"
  FIND_BY_SUBSCRIPTION_ID = "SELECT #{FIELDS.join(',')} FROM skus WHERE subscription_id = ?"
  INSERT                  = 'INSERT INTO skus (product_id, subscription_id, quantity) VALUES (?, ?, ?)'
  UPDATE                  = 'UPDATE skus SET product_id = ?, subscription_id = ?, quantity = ? WHERE sku_id = ?'
  DELETE                  = 'DELETE FROM skus WHERE sku_id = ?'

  sig { returns(T::Array[SKU]) }
  def all
    DB.conn.execute(QUERY_ALL).map do |row|
      SKU.new(id: row[0], product_id: row[1], subscription_id: row[2], quantity: row[3])
    end
  end

  sig { params(id: Integer).returns(T.nilable(SKU)) }
  def find(id)
    row = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil if row.empty?

    SKU.new(id: row[0], product_id: row[1], subscription_id: row[2], quantity: row[3])
  end

  sig { params(ids: T::Array[Integer]).returns(T::Array[SKU]) }
  def find_by_ids(ids)
    raise TooManyIds if ids.size > MAX_IDS

    find_by_ids_statement(ids).execute.map do |row|
      SKU.new(id: row[0], product_id: row[1], subscription_id: row[2], quantity: row[3])
    end
  end

  sig { params(subscription_id: Integer).returns(T::Array[SKU]) }
  def find_by_subscription_id(subscription_id)
    DB.conn.execute(FIND_BY_SUBSCRIPTION_ID, subscription_id).map do |row|
      SKU.new(id: row[0], product_id: row[1], subscription_id: row[2], quantity: row[3])
    end
  end

  sig { params(sku: SKU).returns(SKU) }
  def save(sku)
    sku.id ? update(sku) : insert(sku)
  end

  sig { params(id: Integer).returns(Integer) }
  def delete(id)
    DB.conn.execute(DELETE, id)
    DB.conn.changes
  end

  private

  sig { params(ids: T::Array[Integer]).returns(SQLite3::Statement) }
  def find_by_ids_statement(ids)
    num_ids = if ids.size <= UP_TO_2_IDS
                UP_TO_2_IDS
              elsif ids.size <= UP_TO_10_IDS
                UP_TO_10_IDS
              else
                MAX_IDS
              end

    DB.conn.prepare(FIND_BY_IDS[num_ids]).tap do |stmt|
      stmt.bind_params(ids.fill(T.must(ids.last), ids.size, num_ids - ids.size))
    end
  end

  sig { params(sku: SKU).returns(SKU) }
  def insert(sku)
    DB.conn.execute(INSERT, sku.product_id, sku.subscription_id, sku.quantity)

    sku.tap do |s|
      s.instance_variable_set(:@id, DB.conn.last_insert_row_id)
    end
  end

  sig { params(sku: SKU).returns(SKU) }
  def update(sku)
    DB.conn.execute(UPDATE, sku.product_id, sku.subscription_id, sku.quantity, sku.id)
    sku
  end
end
