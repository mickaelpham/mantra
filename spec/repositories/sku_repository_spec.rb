# typed: false
# frozen_string_literal: true

RSpec.describe SKURepository do
  let(:repo)  { described_class.new }
  let(:a_sku) { SKU.new(product_id: 1, subscription_id: 1, quantity: 3) }

  # Ensure we clean up the database between tests
  after { DB.conn.execute('DELETE FROM skus') }

  describe '#insert' do
    subject(:insert_record) { repo.save(a_sku) }

    it 'persists a new record in the db' do
      expect { repo.save(a_sku) }.to change { repo.all.size }.by(1)
    end

    it 'returns the ID from the record inserted' do
      expect(insert_record.id).not_to be_nil
    end

    it 'does not instantiate a new object' do
      expect(a_sku.object_id).to eq(insert_record.object_id)
    end
  end

  describe '#update' do
    subject(:update_record) do
      a_sku.quantity += 1
      repo.save(a_sku)
    end

    before { repo.save(a_sku) }

    it 'persists the new name in the database' do
      update_record
      same_sku_different_query = repo.find(a_sku.id)

      expect(same_sku_different_query.quantity).to eq(a_sku.quantity)
    end
  end

  describe '#delete' do
    subject(:delete_record) { repo.delete(a_sku_id) }

    context 'when the record does not exist' do
      let(:a_sku_id) { -1 }

      it 'returns 0 records modified' do
        expect(delete_record).to eq(0)
      end

      it 'does change anything in the database' do
        expect { delete_record }.not_to(change { repo.all.size })
      end
    end

    context 'when the record exists' do
      before { repo.save(a_sku) }

      let(:a_sku_id) { a_sku.id }

      it 'returns 1 record modified' do
        expect(delete_record).to eq(1)
      end

      it 'removes the record from the database' do
        expect { delete_record }.to(change { repo.all.size }.by(-1))
      end
    end
  end
end
