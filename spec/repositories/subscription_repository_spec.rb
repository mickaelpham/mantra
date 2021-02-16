# typed: false
# frozen_string_literal: true

RSpec.describe SubscriptionRepository do
  let(:repo)           { described_class.new }
  let(:a_subscription) { Subscription.new }

  # Ensure we clean up the database between tests
  after { DB.conn.execute('DELETE FROM subscriptions') }

  describe '#insert' do
    subject(:insert_record) { repo.save(a_subscription) }

    it 'persists a new record in the db' do
      expect { repo.save(a_subscription) }.to change { repo.all.size }.by(1)
    end

    it 'returns the ID from the record inserted' do
      expect(insert_record.id).not_to be_nil
    end

    it 'does not instantiate a new object' do
      expect(a_subscription.object_id).to eq(insert_record.object_id)
    end
  end

  describe '#find' do
    subject(:find_record) { repo.find(a_subscription.id) }

    before { repo.save(a_subscription) }

    it 'parses #starts_at as a timestamp' do
      expect(find_record.starts_at).to be_a Time
    end

    it 'parses #ends_at as a timestamp' do
      expect(find_record.ends_at).to be_a Time
    end
  end

  describe '#delete' do
    subject(:delete_record) { repo.delete(a_subscription_id) }

    context 'when the record does not exist' do
      let(:a_subscription_id) { -1 }

      it 'returns 0 records modified' do
        expect(delete_record).to eq(0)
      end

      it 'does change anything in the database' do
        expect { delete_record }.not_to(change { repo.all.size })
      end
    end

    context 'when the record exists' do
      before { repo.save(a_subscription) }

      let(:a_subscription_id) { a_subscription.id }

      it 'returns 1 record modified' do
        expect(delete_record).to eq(1)
      end

      it 'removes the record from the database' do
        expect { delete_record }.to(change { repo.all.size }.by(-1))
      end
    end
  end
end
