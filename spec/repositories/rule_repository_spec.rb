# typed: false
# frozen_string_literal: true

RSpec.describe RuleRepository do
  let(:repo)                { described_class.new }
  let(:quantity_constraint) { QuantityConstraint::WallToWall }

  let(:a_rule) do
    Rule.new(
      configured_product_id: 1,
      optional_product_id: 2,
      quantity_constraint: quantity_constraint
    )
  end

  # Ensure we clean up the database between tests
  after { DB.conn.execute('DELETE FROM rules') }

  describe '#insert' do
    subject(:insert_record) { repo.save(a_rule) }

    it 'persists a new record in the db' do
      expect { repo.save(a_rule) }.to change { repo.all.size }.by(1)
    end

    it 'returns the ID from the record inserted' do
      expect(insert_record.id).not_to be_nil
    end

    it 'does not instantiate a new object' do
      expect(a_rule.object_id).to eq(insert_record.object_id)
    end

    context 'when the quantity constraint is nil' do
      let(:quantity_constraint) { nil }

      it 'still persists the record in the db' do
        expect { repo.save(a_rule) }.to change { repo.all.size }.by(1)
      end

      it 'does not call #from_serialized when querying the record' do
        insert_record
        rule = repo.find(a_rule.id)

        expect(rule.quantity_constraint).to be_nil
      end
    end
  end

  describe '#update' do
    subject(:update_record) do
      a_rule.quantity_constraint = QuantityConstraint::LessThanOrEqual
      repo.save(a_rule)
    end

    before { repo.save(a_rule) }

    it 'persists the new name in the database' do
      update_record
      query_again = repo.find(a_rule.id)

      expect(query_again.quantity_constraint).to eq(QuantityConstraint::LessThanOrEqual)
    end
  end

  describe '#delete' do
    subject(:delete_record) { repo.delete(a_rule_id) }

    context 'when the record does not exist' do
      let(:a_rule_id) { -1 }

      it 'returns 0 records modified' do
        expect(delete_record).to eq(0)
      end

      it 'does change anything in the database' do
        expect { delete_record }.not_to(change { repo.all.size })
      end
    end

    context 'when the record exists' do
      before { repo.save(a_rule) }

      let(:a_rule_id) { a_rule.id }

      it 'returns 1 record modified' do
        expect(delete_record).to eq(1)
      end

      it 'removes the record from the database' do
        expect { delete_record }.to(change { repo.all.size }.by(-1))
      end
    end
  end
end
