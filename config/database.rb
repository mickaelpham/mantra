# typed: true
# frozen_string_literal: true

require 'sqlite3'

module DB
  class << self
    def conn
      @conn ||= SQLite3::Database.new("db/#{APP_ENV}.db")
    end
  end
end
