# typed: strict
# frozen_string_literal: true

class Customer < T::Struct
  const :name,          String
  const :subscriptions, T::Array[Subscription], default: []
end
