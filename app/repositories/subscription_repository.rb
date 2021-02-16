# typed: true
# frozen_string_literal: true

class SubscriptionRepository
  extend T::Sig

  FIELDS = %w[subscription_id starts_at ends_at].freeze

  QUERY_ALL  = "SELECT #{FIELDS.join(',')} FROM subscriptions"
  FIND_BY_ID = "SELECT #{FIELDS.join(',')} FROM subscriptions WHERE subscription_id = ?"
  DELETE     = 'DELETE FROM subscriptions WHERE subscription_id = ?'

  INSERT = <<-SQL
    INSERT INTO subscriptions (starts_at, ends_at)
    VALUES (?, ?)
  SQL

  sig { returns(T::Array[Subscription]) }
  def all
    DB.conn.execute(QUERY_ALL).map { |row| subscription_from_row(row) }
  end

  sig { params(id: Integer).returns(T.nilable(Subscription)) }
  def find(id)
    row = DB.conn.get_first_row(FIND_BY_ID, id)
    return nil if row.empty?

    subscription_from_row(row)
  end

  sig { params(subscription: Subscription).returns(Subscription) }
  def save(subscription)
    DB.conn.execute(
      INSERT,
      subscription.starts_at.to_i,
      subscription.ends_at.to_i
    )

    subscription.tap do |s|
      s.instance_variable_set(:@id, DB.conn.last_insert_row_id)
    end
  end

  sig { params(id: Integer).returns(Integer) }
  def delete(id)
    DB.conn.execute(DELETE, id)
    DB.conn.changes
  end

  private

  sig { params(row: SQLite3::ResultSet::ArrayWithTypesAndFields).returns(Subscription) }
  def subscription_from_row(row)
    Subscription.new(
      id: row[0],
      starts_at: Time.at(row[1]),
      ends_at: Time.at(row[2])
    )
  end
end
