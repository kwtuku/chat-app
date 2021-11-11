require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  permissions :index? do
    context 'when not signed in' do
      it 'denies access' do
        expect(described_class).not_to permit(nil, User)
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }

      it 'grants access' do
        expect(described_class).to permit(alice, User)
      end
    end
  end
end
