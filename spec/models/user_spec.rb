require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'create_direct_chat_with(other_user)' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'when other_user != self' do
      it 'increases Entry count' do
        expect do
          alice.create_direct_chat_with(bob)
        end.to change(Entry, :count).by(2)
          .and change(alice.entries, :count).by(1)
          .and change(bob.entries, :count).by(1)
      end

      it 'increases Room count' do
        expect do
          alice.create_direct_chat_with(bob)
        end.to change(Room, :count).by(1)
          .and change(alice.rooms, :count).by(1)
          .and change(bob.rooms, :count).by(1)
      end

      it 'returns Room' do
        room = alice.create_direct_chat_with(bob)
        expect(room.class).to eq Room
      end

      it 'has two users' do
        room = alice.create_direct_chat_with(bob)
        expect(room.users.size).to eq 2
        expect(room.users).to include alice, bob
      end

      it 'is direct chat' do
        room = alice.create_direct_chat_with(bob)
        expect(room.room_type).to eq 'direct'
      end

      it 'has correct slug' do
        room = alice.create_direct_chat_with(bob)
        expect(room.slug).to eq [alice.id, bob.id].sort.join('-')
      end
    end

    context 'when other_user == self' do
      it 'raises Invalid argument' do
        expect do
          alice.create_direct_chat_with(alice)
        end.to raise_error 'Invalid argument'
      end
    end
  end
end
