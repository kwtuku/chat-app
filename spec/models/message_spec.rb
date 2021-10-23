require 'rails_helper'

RSpec.describe Message, type: :model do
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content).is_at_most(500) }
end
