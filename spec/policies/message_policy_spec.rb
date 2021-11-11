require 'rails_helper'

RSpec.describe MessagePolicy, type: :policy do
  let(:alice) { create :user }
  let(:bob) { create :user }
  let(:message) do
    carol = create :user
    room = create :room
    create :entry, room: room, user: alice
    create :entry, room: room, user: carol
    build_stubbed :message, room: room, user: alice
  end

  permissions :create? do
    context 'when not signed in' do
      it 'denies access' do
        expect(described_class).not_to permit(nil, message)
      end
    end

    context 'when signed in as unauthorized user' do
      it 'denies access' do
        expect(described_class).not_to permit(bob, message)
      end
    end

    context 'when signed in as authorized user' do
      it 'grants access' do
        expect(described_class).to permit(alice, message)
      end
    end
  end
end
