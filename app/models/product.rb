# typed: strict
# frozen_string_literal: true

class Product < T::Struct
  const :id,   T.nilable(Integer)
  prop  :name, String
end
