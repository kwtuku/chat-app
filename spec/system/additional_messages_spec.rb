require 'rails_helper'

RSpec.describe 'AdditionalMessages', type: :system do
  let(:alice) { create :user }
  let(:room) { create :room }
  let(:messages) { alice.messages.order(id: :DESC) }

  before do
    create :entry, room: room, user: alice
    create_list :message, 101, room: room, user: alice
  end

  it 'can infinite scroll', js: true do
    sign_in alice
    visit room_path(room)
    expect(page).to have_css "[data-rspec=message_#{messages[49].id}]"
    expect(page).not_to have_css "[data-rspec=message_#{messages[50].id}]"

    scrollable_area = find('[data-rspec=scrollable_area]')
    scrollable_area.scroll_to(0, 0)

    expect(page).to have_css "[data-rspec=message_#{messages[50].id}]"
    expect(page).to have_css "[data-rspec=message_#{messages[99].id}]"
    expect(page).not_to have_css "[data-rspec=message_#{messages[100].id}]"

    scrollable_area.scroll_to(0, 0)

    expect(page).to have_css "[data-rspec=message_#{messages[100].id}]"
  end
end
