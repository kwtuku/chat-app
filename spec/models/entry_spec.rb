require 'rails_helper'

RSpec.describe Entry, type: :model do
  it { is_expected.to validate_presence_of(:room_id) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_uniqueness_of(:room_id).scoped_to(:user_id) }
end
