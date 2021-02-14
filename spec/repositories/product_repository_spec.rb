# typed: false
# frozen_string_literal: true

RSpec.describe ProductRepository do
  let(:repo)      { described_class.new }
  let(:a_name)    { 'My Amazing Product' }
  let(:a_product) { Product.new(name: a_name) }

  # Ensure we clean up the database between tests
  after(:each) { DB.conn.execute('DELETE FROM products') }

  describe '#insert' do
    subject(:insert_record) { repo.save(a_product) }

    it 'persists a new record in the db' do
      expect { repo.save(a_product) }.to change { repo.all.size }.by(1)
    end

    it 'returns the ID from the record inserted' do
      expect(subject.id).to_not be_nil
    end

    it 'does not instantiate a new object' do
      expect(a_product.object_id).to eq(subject.object_id)
    end
  end

  describe '#update' do
    before { repo.save(a_product) }

    let(:another_name) { 'My other product name' }

    subject(:update_record) do
      a_product.name = another_name
      repo.save(a_product)
    end

    it 'persists the new name in the database' do
      update_record
      same_product_different_query = repo.find(a_product.id)

      expect(same_product_different_query.name).to eq(a_product.name)
    end
  end

  describe '#delete' do
    subject(:delete_record) { repo.delete(a_product_id) }

    context 'when the record does not exist' do
      let(:a_product_id) { -1 }

      it 'returns 0 records modified' do
        expect(delete_record).to eq(0)
      end

      it 'does change anything in the database' do
        expect { delete_record }.to_not(change { repo.all.size })
      end
    end

    context 'when the record exists' do
      before { repo.save(a_product) }

      let(:a_product_id) { a_product.id }

      it 'returns 1 record modified' do
        expect(delete_record).to eq(1)
      end

      it 'removes the record from the database' do
        expect { delete_record }.to(change { repo.all.size }.by(-1))
      end
    end
  end
end
