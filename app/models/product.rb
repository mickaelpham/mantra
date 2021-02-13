# typed: strict
# frozen_string_literal: true

class Product < T::Struct
  const :id,   Integer
  const :name, String
end
