# typed: strict
# frozen_string_literal: true

class Subscription < T::Struct
  const :skus, T::Array[SKU], default: []
  const :starts_at, Time, default: Time.now
  const :ends_at, Time, default: Time.now + 24 * 86_400 * 30
  const :customer, Customer
end
