# typed: false
# frozen_string_literal: true

class Customer < T::Struct
  prop  :name,          String
  const :subscriptions, T::Array[Subscription], default: []
end
