require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'find_or_create_direct_chat_with(other_user)' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'when other_user == self' do
      it 'raises Invalid argument' do
        expect do
          alice.find_or_create_direct_chat_with(alice)
        end.to raise_error 'Invalid argument'
      end
    end

    context 'when other_user != self and room exists' do
      before do
        slug = [alice, bob].map(&:id).sort.join('-')
        room = create :room, slug: slug, room_type: 'direct'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
      end

      it 'does not increase Entry count' do
        expect do
          alice.find_or_create_direct_chat_with(bob)
        end.to change(Entry, :count).by(0)
          .and change(alice.entries, :count).by(0)
          .and change(bob.entries, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          alice.find_or_create_direct_chat_with(bob)
        end.to change(Room, :count).by(0)
          .and change(alice.rooms, :count).by(0)
          .and change(bob.rooms, :count).by(0)
      end

      it 'has two users' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.users.size).to eq 2
        expect(room.users).to include alice, bob
      end

      it 'returns Room' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.class).to eq Room
      end

      it 'is direct chat' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.room_type).to eq 'direct'
      end

      it 'has correct slug' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.slug).to eq [alice.id, bob.id].sort.join('-')
      end
    end

    context 'when other_user != self and room does not exist' do
      it 'increases Entry count' do
        expect do
          alice.find_or_create_direct_chat_with(bob)
        end.to change(Entry, :count).by(2)
          .and change(alice.entries, :count).by(1)
          .and change(bob.entries, :count).by(1)
      end

      it 'increases Room count' do
        expect do
          alice.find_or_create_direct_chat_with(bob)
        end.to change(Room, :count).by(1)
          .and change(alice.rooms, :count).by(1)
          .and change(bob.rooms, :count).by(1)
      end

      it 'has two users' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.users.size).to eq 2
        expect(room.users).to include alice, bob
      end

      it 'returns Room' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.class).to eq Room
      end

      it 'is direct chat' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.room_type).to eq 'direct'
      end

      it 'has correct slug' do
        room = alice.find_or_create_direct_chat_with(bob)
        expect(room.slug).to eq [alice.id, bob.id].sort.join('-')
      end
    end
  end

  describe 'create_group_chat_with(other_users)' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:carol) { create :user }

    context 'when other_users has self' do
      let(:other_users_with_self) { described_class.find(alice.id, bob.id) }

      it 'increases correct Entry count' do
        expect do
          alice.create_group_chat_with(other_users_with_self)
        end.to change(Entry, :count).by(2)
          .and change(alice.entries, :count).by(1)
          .and change(bob.entries, :count).by(1)
      end

      it 'increases correct Room count' do
        expect do
          alice.create_group_chat_with(other_users_with_self)
        end.to change(Room, :count).by(1)
          .and change(alice.rooms, :count).by(1)
          .and change(bob.rooms, :count).by(1)
      end
    end

    context 'when other_users does not have self' do
      let(:other_users) { described_class.find(bob.id, carol.id) }

      it 'increases correct Entry count' do
        expect do
          alice.create_group_chat_with(other_users)
        end.to change(Entry, :count).by(3)
          .and change(alice.entries, :count).by(1)
          .and change(bob.entries, :count).by(1)
          .and change(carol.entries, :count).by(1)
      end

      it 'increases correct Room count' do
        expect do
          alice.create_group_chat_with(other_users)
        end.to change(Room, :count).by(1)
          .and change(alice.rooms, :count).by(1)
          .and change(bob.rooms, :count).by(1)
          .and change(carol.rooms, :count).by(1)
      end

      it 'has correct users' do
        room = alice.create_group_chat_with(other_users)
        expect(room.users.size).to eq 3
        expect(room.users).to include alice, bob, carol
      end

      it 'returns Room' do
        room = alice.create_group_chat_with(other_users)
        expect(room.class).to eq Room
      end

      it 'is group chat' do
        room = alice.create_group_chat_with(other_users)
        expect(room.room_type).to eq 'group'
      end

      it 'has correct name' do
        room = alice.create_group_chat_with(other_users)
        expect(room.name).to eq [alice, bob, carol].map(&:name).sort.join(', ')
      end
    end
  end
end
