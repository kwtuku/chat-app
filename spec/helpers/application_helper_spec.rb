require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'other_user(room, user)' do
    it 'returns correct user' do
      alice = create :user
      bob = create :user
      room = create :room, room_type: 'direct'
      create :entry, room: room, user: alice
      create :entry, room: room, user: bob
      expect(helper.other_user(room, alice)).to eq bob
    end
  end

  describe 'room_image_url(room, user)' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'when room type is direct' do
      it 'returns other user avatar url' do
        room = create :room, room_type: 'direct'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
        expect(helper.room_image_url(room, alice)).to eq bob.avatar.icon.url
      end
    end

    context 'when room type is group' do
      it 'returns placehold image url' do
        room = create :room, room_type: 'group'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
        expect(helper.room_image_url(room, alice)).to eq 'https://placehold.jp/150x150.png'
      end
    end
  end

  describe 'room_name(room, user)' do
    let(:alice) { create :user }
    let(:bob) { create :user }

    context 'when room type is direct' do
      it 'returns other user name' do
        room = create :room, room_type: 'direct'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
        expect(helper.room_name(room, alice)).to eq bob.name
      end
    end

    context 'when room type is group' do
      it 'returns room name' do
        name = [alice, bob].sort.map(&:name).join(', ')
        room = create :room, name: name, room_type: 'group'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
        expect(helper.room_name(room, alice)).to eq name
      end
    end
  end
end
