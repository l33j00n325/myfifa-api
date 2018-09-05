require 'rails_helper'

RSpec.describe TransfersController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:team) { FactoryBot.create(:team, user: user) }
  let(:player) { FactoryBot.create(:player, team: team) }
  let(:application) {
    Doorkeeper::Application.create!(
      name: Faker::Company.name,
      redirect_uri: "https://#{Faker::Internet.domain_name}"
    )
  }
  let(:token) {
    Doorkeeper::AccessToken.create!(
      application: application,
      resource_owner_id: user.id
    )
  }

  describe 'GET #index' do
    it 'requires a valid token' do
      get player_transfers_url(player)
      assert_response 401
    end

    it 'returns all Transfers of select Player' do
      transfer = FactoryBot.create_list :transfer, 10, player: player
      another_player = FactoryBot.create :player, team: team
      FactoryBot.create :transfer, player: another_player

      get player_transfers_url(player),
          headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
      expect(json).to be == JSON.parse(player.transfers.to_json)
    end
  end

  describe 'GET #show' do
    it 'requires a valid token' do
      transfer = FactoryBot.create :transfer, player: player
      get transfer_url(transfer)
      assert_response 401
    end

    it 'returns Player JSON with History' do
      transfer = FactoryBot.create :transfer, player: player

      get transfer_url(transfer),
          headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
      expect(json).to be == JSON.parse(transfer.to_json)
    end
  end

  describe 'POST #create' do
    before :each do |test|
      unless test.metadata[:skip_before]
        post player_transfers_url(player),
             headers: { 'Authorization' => "Bearer #{token.token}" },
             params: { transfer: FactoryBot.attributes_for(:transfer) }
      end
    end

    it 'requires a valid token', skip_before: true do
      post player_transfers_url(player),
           params: { team: FactoryBot.attributes_for(:player) }
      assert_response 401
    end

    it 'creates a new Transfer' do
      expect(Transfer.count).to be == 1
    end

    it 'returns Player JSON' do
      player.reload
      expect(json).to be == JSON.parse(player.to_json)
    end
  end

  describe 'PATCH #update' do
    it 'requires a valid token' do
      @transfer = FactoryBot.create :transfer, player: player
      patch transfer_url(@transfer),
            params: { transfer: FactoryBot.attributes_for(:transfer) }
      assert_response 401
    end

    it 'rejects requests from other Users' do
      @transfer = FactoryBot.create :transfer
      patch transfer_url(@transfer),
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { transfer: FactoryBot.attributes_for(:transfer) }
      assert_response 403
    end

    it 'returns updated Player JSON' do
      @transfer = FactoryBot.create :transfer, player: player
      patch transfer_url(@transfer),
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { transfer: FactoryBot.attributes_for(:transfer) }
      @transfer.reload
      expect(json).to be == JSON.parse(player.to_json)
    end
  end

  describe 'DELETE #destroy' do
    it 'requires a valid token' do
      @transfer = FactoryBot.create :transfer, player: player
      delete transfer_url(@transfer)
      assert_response 401
    end

    it 'rejects requests from other Users' do
      @transfer = FactoryBot.create :transfer
      delete transfer_url(@transfer),
             headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response 403
    end

    it 'removes the Player' do
      @transfer = FactoryBot.create :transfer, player: player
      delete transfer_url(@transfer),
             headers: { 'Authorization' => "Bearer #{token.token}" }
      expect { @transfer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end