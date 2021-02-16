# typed: true
# frozen_string_literal: true

class RuleRepository
  extend T::Sig

  FIELDS = %w[rule_id configured_product_id optional_product_id quantity_constraint].freeze

  QUERY_ALL  = "SELECT #{FIELDS.join(',')} FROM rules"
  FIND_BY_ID = "SELECT #{FIELDS.join(',')} FROM rules WHERE rule_id = ?"
  DELETE     = 'DELETE FROM rules WHERE rule_id = ?'

  INSERT = <<-SQL
    INSERT INTO rules (configured_product_id, optional_product_id, quantity_constraint)
    VALUES (?, ?, ?)
  SQL

  UPDATE = <<-SQL
    UPDATE rules
    SET configured_product_id = ?,
        optional_product_id = ?,
        quantity_constraint = ?
    WHERE rule_id = ?
  SQL

  sig { returns(T::Array[Rule]) }
  def all
    DB.conn.execute(QUERY_ALL).map { |row| rule_from_row(row) }
  end

  sig { params(id: Integer).returns(T.nilable(Rule)) }
  def find(id)
    row = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil if row.empty?

    rule_from_row(row)
  end

  sig { params(rule: Rule).returns(Rule) }
  def save(rule)
    rule.id ? update(rule) : insert(rule)
  end

  sig { params(id: Integer).returns(Integer) }
  def delete(id)
    DB.conn.execute(DELETE, id)
    DB.conn.changes
  end

  private

  sig { params(row: SQLite3::ResultSet::ArrayWithTypesAndFields).returns(Rule) }
  def rule_from_row(row)
    Rule.new(
      id: row[0],
      configured_product_id: row[1],
      optional_product_id: row[2],
      quantity_constraint: row[3] ? QuantityConstraint.from_serialized(row[3]) : nil
    )
  end

  sig { params(rule: Rule).returns(Rule) }
  def insert(rule)
    DB.conn.execute(
      INSERT,
      rule.configured_product_id,
      rule.optional_product_id,
      rule.quantity_constraint&.serialize
    )

    rule.tap do |r|
      r.instance_variable_set(:@id, DB.conn.last_insert_row_id)
    end
  end

  sig { params(rule: Rule).returns(Rule) }
  def update(rule)
    DB.conn.execute(
      UPDATE,
      rule.configured_product_id,
      rule.optional_product_id,
      rule.quantity_constraint&.serialize,
      rule.id
    )

    rule
  end
end
