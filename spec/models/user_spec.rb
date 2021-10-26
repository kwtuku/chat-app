require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'create_room_with' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    it 'increases Entry count' do
      expect do
        alice.create_room_with(bob)
      end.to change(Entry, :count).by(2)
        .and change(alice.entries, :count).by(1)
        .and change(bob.entries, :count).by(1)
    end

    it 'increases Room count' do
      expect do
        alice.create_room_with(bob)
      end.to change(Room, :count).by(1)
        .and change(alice.rooms, :count).by(1)
        .and change(bob.rooms, :count).by(1)
    end

    it 'returns Room' do
      room = alice.create_room_with(bob)
      expect(room.class).to eq Room
    end

    it 'has users' do
      room = alice.create_room_with(bob)
      expect(room.users).to include alice, bob
    end
  end
end
