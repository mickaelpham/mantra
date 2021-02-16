# typed: false
# frozen_string_literal: true

RSpec.describe Rule do
  let(:a_rule) { build(:rule) }

  describe '#configured' do
    subject { a_rule.configured }
    it { is_expected.to be_a(Product) }
  end

  describe '#optional' do
    subject { a_rule.optional }
    it { is_expected.to be_a(Product) }
  end

  describe '#quantity_constraint' do
    subject { a_rule.quantity_constraint }

    context 'can be nil' do
      it { is_expected.to be_nil }
    end

    context 'can be wall to wall' do
      let(:a_rule) { build(:rule, :wall_to_wall) }
      it { is_expected.to eq(QuantityConstraint::WallToWall) }
    end

    context 'can be less than or equal' do
      let(:a_rule) { build(:rule, :less_than_or_equal) }
      it { is_expected.to eq(QuantityConstraint::LessThanOrEqual) }
    end
  end

  describe '#valid_given?' do
    subject { a_rule.valid_given?(skus) }

    context 'SKUs with neither configured nor optional matching product' do
      let(:skus) { build_list(:sku, 2) }
      it { is_expected.to be(true) }
    end

    context 'SKUs with matching configured but not optional product' do
      let(:skus) { [build(:sku), build(:sku, product: a_rule.configured)] }
      it { is_expected.to be(true) }
    end

    context 'SKUs with matching optional but not configured product' do
      let(:skus) { [build(:sku), build(:sku, product: a_rule.optional)] }
      it { is_expected.to be(true) }
    end

    context 'SKUs with matching optional and configured product' do
      let(:skus) do
        [
          build(:sku, product: a_rule.configured, quantity: configured_qty),
          build(:sku, product: a_rule.optional,   quantity: optional_qty)
        ]
      end

      context 'when wall to wall' do
        let(:a_rule) { build(:rule, :wall_to_wall) }

        context 'and the quantities match' do
          let(:configured_qty) { 3 }
          let(:optional_qty)   { 3 }

          it { is_expected.to be(true) }
        end

        context 'and the quantities do not match' do
          let(:configured_qty) { 3 }
          let(:optional_qty)   { 5 }

          it { is_expected.to be(false) }
        end
      end

      context 'when less than or equal' do
        let(:a_rule) { build(:rule, :less_than_or_equal) }

        context 'and the quantities comply' do
          let(:configured_qty) { 3 }
          let(:optional_qty)   { 2 }

          it { is_expected.to be(true) }
        end

        context 'and the quantities do not comply' do
          let(:configured_qty) { 3 }
          let(:optional_qty)   { 4 }

          it { is_expected.to be(false) }
        end
      end
    end
  end
end
