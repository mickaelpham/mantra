# typed: true
# frozen_string_literal: true

class RuleRepository
  extend Forwardable
  extend T::Sig

  def all
    execute('SELECT * FROM rules') do |row|
      p row
    end
  end

  def_delegator :DB, :conn
  def_delegator :conn, :execute
end
