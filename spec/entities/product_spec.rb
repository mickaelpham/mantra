# typed: false
# frozen_string_literal: true

RSpec.describe Product do
  let(:a_name)    { 'My Super Product' }
  let(:a_product) { build(:product, name: a_name) }

  it 'has a name' do
    expect(a_product.name).to eq(a_name)
  end
end
