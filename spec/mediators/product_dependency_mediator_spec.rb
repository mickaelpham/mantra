# typed: false
# frozen_string_literal: false

RSpec.describe ProductDependencyMediator do
  let(:a_product)          { build(:product, id: nil) }
  let(:an_anchor_product)  { build(:product, :as_anchor, id: nil) }
  let(:product_repository) { ProductRepository.new }

  before do
    product_repository.save(a_product)
    product_repository.save(an_anchor_product)
  end

  after do
    product_repository.delete(a_product.id)
    product_repository.delete(an_anchor_product.id)
  end

  describe '#valid?' do
    subject { described_class.new(rules, skus).valid? }

    context 'when there are only anchor products and no rules' do
      let(:rules) { [] }
      let(:skus)  { build_list(:sku, 2, product_id: an_anchor_product.id) }

      it { is_expected.to be(true) }
    end

    context 'when there is an anchor product and an optional product' do
      let(:rules) do
        [build(:rule, configured_product_id: an_anchor_product.id, optional_product_id: a_product.id)]
      end

      let(:skus) do
        [
          build(:sku, product_id: an_anchor_product.id),
          build(:sku, product_id: a_product.id)
        ]
      end

      it { is_expected.to be(true) }
    end

    context 'when there is an optional product but no anchor product' do
      let(:rules) do
        [build(:rule, configured_product_id: an_anchor_product.id, optional_product_id: a_product.id)]
      end

      let(:skus) do
        [build(:sku, product_id: a_product.id)]
      end

      it { is_expected.to be(false) }
    end
  end
end
