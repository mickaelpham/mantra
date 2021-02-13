# typed: true
# frozen_string_literal: true

class RuleRepository
  extend T::Sig

  def all
    DB.conn.execute('SELECT * FROM rules') do |row|
      p row
    end
  end
end
