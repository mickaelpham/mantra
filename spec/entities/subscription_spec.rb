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

  describe '#compliant_with?' do
    subject { a_subscription.compliant_with?(rules) }

    let(:compliant_rule)     { instance_double(Rule, valid_given?: true) }
    let(:non_compliant_rule) { instance_double(Rule, valid_given?: false) }

    context 'when all the rules are validated' do
      let(:rules) { [compliant_rule] }

      it { is_expected.to be(true) }
    end

    context 'when at least one rule is not validated' do
      let(:rules) { [compliant_rule, non_compliant_rule] }

      it { is_expected.to be(false) }
    end
  end
end
