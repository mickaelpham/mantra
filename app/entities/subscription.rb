# typed: strict
# frozen_string_literal: true

class Subscription < T::Struct
  extend T::Sig

  const :id,        T.nilable(Integer)
  const :starts_at, Time,              default: Time.now
  const :ends_at,   Time,              default: Time.now + 24 * 86_400 * 30

  sig { params(rules: T::Array[Rule]).returns(T::Boolean) }
  def compliant_with?(rules)
    skus = SKURepository.new.find_by_subscription_id(T.must(id))

    rules.all? { |rule| rule.valid_given?(skus) }
  end
end
