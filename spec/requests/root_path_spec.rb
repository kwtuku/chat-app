require 'rails_helper'

RSpec.describe 'RootPath', type: :request do
  describe 'GET /' do
    context 'when not signed in' do
      it 'returns a 200 response' do
        get root_path
        expect(response.status).to eq 200
      end

      it 'matches Sessions#new' do
        get root_path
        expect(controller.controller_name).to eq 'sessions'
        expect(controller.action_name).to eq 'new'
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }

      before { sign_in alice }

      it 'returns a 200 response' do
        get root_path
        expect(response.status).to eq 200
      end

      it 'matches Rooms#index' do
        get root_path
        expect(controller.controller_name).to eq 'rooms'
        expect(controller.action_name).to eq 'index'
      end
    end
  end
end
