# typed: false
# frozen_string_literal: true

RSpec.describe Customer do
  let(:a_name)     { 'Jane Doe' }
  let(:a_customer) { build(:customer, name: a_name) }

  describe '#name' do
    subject { a_customer.name }
    it { is_expected.to eq(a_name) }
  end

  describe '#subscriptions' do
    subject { a_customer.subscriptions }
    it { is_expected.to all(be_a Subscription) }
  end
end
