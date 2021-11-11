require 'rails_helper'

RSpec.describe RoomPolicy, type: :policy do
  permissions :index? do
    context 'when not signed in' do
      it 'denies access' do
        expect(described_class).not_to permit(nil, User)
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }

      it 'grants access' do
        expect(described_class).to permit(alice, User)
      end
    end
  end

  permissions :show? do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:room) do
      carol = create :user
      room = create :room
      create :entry, room: room, user: alice
      create :entry, room: room, user: carol
      room
    end

    context 'when not signed in' do
      it 'denies access' do
        expect(described_class).not_to permit(nil, room)
      end
    end

    context 'when signed in as unauthorized user' do
      it 'denies access' do
        expect(described_class).not_to permit(bob, room)
      end
    end

    context 'when signed in as authorized user' do
      it 'grants access' do
        expect(described_class).to permit(alice, room)
      end
    end
  end
end
