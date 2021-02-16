# typed: false
# frozen_string_literal: true

RSpec.describe Rule do
  let(:a_rule) { build(:rule) }

  describe '#configured_product_id' do
    subject { a_rule.configured_product_id }

    it { is_expected.to be_an Integer }
  end

  describe '#optional_product_id' do
    subject { a_rule.optional_product_id }

    it { is_expected.to be_an Integer }
  end

  describe '#quantity_constraint' do
    subject { a_rule.quantity_constraint }

    context 'without one' do
      it { is_expected.to be_nil }
    end

    context 'when wall to wall' do
      let(:a_rule) { build(:rule, :wall_to_wall) }

      it { is_expected.to eq(QuantityConstraint::WallToWall) }
    end

    context 'when less than or equal' do
      let(:a_rule) { build(:rule, :less_than_or_equal) }

      it { is_expected.to eq(QuantityConstraint::LessThanOrEqual) }
    end
  end

  describe '#valid_given?' do
    subject { a_rule.valid_given?(skus) }

    let(:skus) do
      [
        build(:sku, product_id: a_rule.configured_product_id, quantity: configured_qty),
        build(:sku, product_id: a_rule.optional_product_id,   quantity: optional_qty)
      ]
    end

    context 'when wall to wall and the quantities match' do
      let(:a_rule)         { build(:rule, :wall_to_wall) }
      let(:configured_qty) { 3 }
      let(:optional_qty)   { 3 }

      it { is_expected.to be(true) }
    end

    context 'when wall to wall and the quantities do not match' do
      let(:a_rule)         { build(:rule, :wall_to_wall) }
      let(:configured_qty) { 3 }
      let(:optional_qty)   { 5 }

      it { is_expected.to be(false) }
    end

    context 'when less than or equal and the quantities comply' do
      let(:a_rule)         { build(:rule, :less_than_or_equal) }
      let(:configured_qty) { 3 }
      let(:optional_qty)   { 2 }

      it { is_expected.to be(true) }
    end

    context 'when less than or equal and the quantities do not comply' do
      let(:a_rule)         { build(:rule, :less_than_or_equal) }
      let(:configured_qty) { 3 }
      let(:optional_qty)   { 4 }

      it { is_expected.to be(false) }
    end

    context 'when SKUs are not matching neither configured nor optional product' do
      let(:skus) { build_list(:sku, 2) }

      it { is_expected.to be(true) }
    end

    context 'when SKUs are matching configured but not optional product' do
      let(:skus) { [build(:sku), build(:sku, product_id: a_rule.configured_product_id)] }

      it { is_expected.to be(true) }
    end

    context 'when SKUs are matching optional but not configured product' do
      let(:skus) { [build(:sku), build(:sku, product_id: a_rule.optional_product_id)] }

      it { is_expected.to be(true) }
    end
  end
end
