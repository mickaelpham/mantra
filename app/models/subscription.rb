# typed: strict
# frozen_string_literal: true

class Subscription < T::Struct
  extend T::Sig

  const :skus,      T::Array[SKU], default: []
  const :starts_at, Time,          default: Time.now
  const :ends_at,   Time,          default: Time.now + 24 * 86_400 * 30

  sig { returns(NilClass) }
  def valid?
    # Find all the rules
    # Only select applicable rules
    # Ensure each rule constraint are met
  end
end
