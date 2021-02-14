# typed: strict
# frozen_string_literal: true

require 'sqlite3'

class DB
  extend T::Sig

  sig { returns(SQLite3::Database) }
  def self.conn
    @conn = T.let(@conn, T.nilable(SQLite3::Database))
    @conn ||= SQLite3::Database.new(db_name)
  end

  sig { returns(String) }
  def self.db_name
    APP_ENV.casecmp?('test') ? ':memory:' : "db/#{APP_ENV}.db"
  end
end
