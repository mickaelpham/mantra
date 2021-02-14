# typed: false
# frozen_string_literal: true

RSpec.describe Subscription do
  let(:another_sku)    { build(:sku) }
  let(:a_subscription) { build(:subscription) }

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
    expect { a_subscription.skus << another_sku }.to change { a_subscription.skus.size }.by(1)
  end
end
