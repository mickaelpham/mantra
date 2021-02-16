# typed: false
# frozen_string_literal: true

RSpec.describe SKU do
  let(:a_sku) { build(:sku) }

  it 'has a quantity' do
    expect(a_sku.quantity).to be_an(Integer)
  end

  it 'references a product' do
    expect(a_sku.product).to be_a(Product)
  end

  it 'can have its quantity changed' do
    expect { a_sku.quantity += 2 }.to change(a_sku, :quantity).from(1).to(3)
  end

  it 'cannot have its product changed' do
    expect(a_sku).not_to respond_to(:product=)
  end
end
