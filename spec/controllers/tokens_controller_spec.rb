# frozen_string_literal: true

require 'rails_helper'

describe TokensController, type: :request do
  let(:user) { create :user }
  let(:application) do
    Doorkeeper::Application.create! name: Faker::Company.name,
                                    redirect_uri: "https://#{Faker::Internet.domain_name}"
  end
  let(:token) do
    Doorkeeper::AccessToken.create! application: application,
                                    resource_owner_id: user.id
  end

  describe 'POST tokens#create' do
    it 'creates a token' do
      post oauth_token_url,
           params: { grant_type: 'password',
                     username: user.username,
                     password: user.password,
                     client_id: application.uid,
                     client_secret: application.secret }
      assert_response :success
    end
  end

  describe 'POST tokens#revoke' do
    it 'removes a token' do
      post oauth_revoke_url,
           params: { client_id: application.uid,
                     client_secret: application.secret },
           headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
    end
  end
end
