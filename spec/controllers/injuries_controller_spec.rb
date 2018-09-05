require 'rails_helper'

RSpec.describe InjuriesController, type: :request do
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
      get player_injuries_url(player)
      assert_response 401
    end

    it 'returns all Injuries of select Player' do
      10.times do
        injury = FactoryBot.create :injury, player: player
        injury.update(recovered: true)
      end

      another_player = FactoryBot.create :player, team: team
      FactoryBot.create :injury, player: another_player

      get player_injuries_url(player),
          headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
      expect(json).to be == JSON.parse(player.injuries.to_json)
    end
  end

  describe 'GET #show' do
    it 'requires a valid token' do
      injury = FactoryBot.create :injury, player: player
      get injury_url(injury)
      assert_response 401
    end

    it 'returns Injury JSON' do
      injury = FactoryBot.create :injury, player: player

      get injury_url(injury),
          headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
      expect(json).to be == JSON.parse(injury.to_json)
    end
  end

  describe 'POST #create' do
    before :each do |test|
      unless test.metadata[:skip_before]
        post player_injuries_url(player),
             headers: { 'Authorization' => "Bearer #{token.token}" },
             params: { injury: FactoryBot.attributes_for(:injury) }
      end
    end

    it 'requires a valid token', skip_before: true do
      post player_injuries_url(player),
           params: { team: FactoryBot.attributes_for(:player) }
      assert_response 401
    end

    it 'creates a new Injury' do
      expect(Injury.count).to be == 1
    end

    it 'returns Player JSON' do
      player.reload
      expect(json).to be == JSON.parse(player.to_json)
    end
  end

  describe 'PATCH #update' do
    it 'requires a valid token', skip_before: true do
      @injury = FactoryBot.create :injury, player: player
      patch injury_url(@injury),
            params: { injury: FactoryBot.attributes_for(:injury) }
      assert_response 401
    end

    it 'rejects requests from other Users', skip_before: true do
      @injury = FactoryBot.create :injury
      patch injury_url(@injury),
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { injury: FactoryBot.attributes_for(:injury) }
      assert_response 403
    end

    it 'returns updated Player JSON' do
      @injury = FactoryBot.create :injury, player: player
      patch injury_url(@injury),
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { injury: FactoryBot.attributes_for(:injury) }
      @injury.reload
      expect(json).to be == JSON.parse(player.to_json)
    end
  end

  describe 'DELETE #destroy' do
    it 'requires a valid token', skip_before: true do
      @injury = FactoryBot.create :injury, player: player
      delete injury_url(@injury)
      assert_response 401
    end

    it 'rejects requests from other Users', skip_before: true do
      @injury = FactoryBot.create :injury
      delete injury_url(@injury),
             headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response 403
    end

    it 'removes the Player' do
      @injury = FactoryBot.create :injury, player: player
      delete injury_url(@injury),
             headers: { 'Authorization' => "Bearer #{token.token}" }
      expect { @injury.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end