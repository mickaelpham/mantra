# typed: strict
# frozen_string_literal: true

class Customer < T::Struct
  const :id,               T.nilable(Integer)
  const :name,             String
  const :subscription_ids, T::Array[Integer], default: []
end
