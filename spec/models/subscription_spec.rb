# typed: false
# frozen_string_literal: true

RSpec.describe Subscription do
  let(:a_product)      { Product.new(id: 1, name: 'My Wonderful Product') }
  let(:a_sku)          { SKU.new(product: a_product, quantity: 2) }
  let(:another_sku)    { SKU.new(product: a_product, quantity: 5) }
  let(:a_subscription) { Subscription.new(skus: [a_sku]) }

  it 'has a start time' do
    expect(a_subscription.starts_at).to be_a(Time)
  end

  it 'has an expiration time, greater than the start time' do
    expect(a_subscription.ends_at).to be > a_subscription.starts_at
  end

  it 'has an array of SKUs' do
    expect(a_subscription.skus).to all(be_a(SKU))
  end

  it 'accepts additional SKUs' do
    expect { a_subscription.skus << another_sku }.to change { a_subscription.skus.size }.from(1).to(2)
  end
end
