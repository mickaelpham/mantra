# typed: false
# frozen_string_literal: true

RSpec.describe Product do
  let(:product_name) { 'My Product' }

  it 'has a name' do
    a_product = Product.new
    a_product.name = product_name

    expect(a_product.name).to eq(product_name)
  end
end
