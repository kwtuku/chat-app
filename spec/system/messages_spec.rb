require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  let(:alice) { create :user }
  let(:room) { create :room }

  before do
    bob = create :user
    create :entry, room: room, user: alice
    create :entry, room: room, user: bob
  end

  it 'creates a message', js: true do
    expect(Message.count).to eq 0
    expect(room.messages.count).to eq 0
    expect(alice.messages.count).to eq 0

    sign_in alice
    visit room_path(room)
    fill_in 'message[content]', with: 'Hi!'
    find('[data-rspec=create_message]').click

    expect(page).to have_selector('[data-rspec^=message_]')
    expect(Message.count).to eq 1
    expect(room.messages.count).to eq 1
    expect(alice.messages.count).to eq 1
  end
end
