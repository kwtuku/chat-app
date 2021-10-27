require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'validations' do
    it { is_expected.to define_enum_for(:room_type).with_values(direct: 0, group: 1).with_suffix(:chat) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:room_type) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
