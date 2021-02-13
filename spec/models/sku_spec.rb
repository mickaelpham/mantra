# typed: false
# frozen_string_literal: true

RSpec.describe SKU do
  let(:a_product) { Product.new(name: 'My Wonderful Product') }
  let(:a_sku)     { SKU.new(product: a_product) }

  it 'has a default quantity' do
    expect(a_sku.quantity).to eq(1)
  end

  it 'references a product' do
    expect(a_sku.product).to be_a(Product)
  end

  it 'can have its quantity changed' do
    expect { a_sku.quantity += 2 }.to change { a_sku.quantity }.from(1).to(3)
  end
end
