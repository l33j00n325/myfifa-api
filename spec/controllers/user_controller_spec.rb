# frozen_string_literal: true

require 'rails_helper'

describe UserController, type: :request do
  let(:user) { create :user }
  let(:application) do
    Doorkeeper::Application.create! name: Faker::Company.name,
                                    redirect_uri: "https://#{Faker::Internet.domain_name}"
  end
  let(:token) do
    Doorkeeper::AccessToken.create! application: application,
                                    resource_owner_id: user.id
  end

  describe 'POST user#create' do
    before do
      post user_url,
           params: { user: attributes_for(:user) }
    end

    it 'creates a user' do
      expect(User.count).to be == 1
    end

    it 'returns with created status' do
      assert_response :created
    end

    it 'returns the User information' do
      expect(json).to be == JSON.parse(User.last.to_json)
    end
  end

  describe 'GET user#show' do
    it 'requires a valid token' do
      get user_url
      assert_response :unauthorized
    end

    it 'returns token owner as user' do
      get user_url,
          headers: { 'Authorization' => "Bearer #{token.token}" }
      assert_response :success
      expect(json).to be == user.as_json
    end
  end

  describe 'PATCH user#update' do
    it 'requires a valid token' do
      patch user_url
      assert_response :unauthorized
    end

    it 'updates user information' do
      old_user = user.as_json
      patch user_url,
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { user: attributes_for(:user, password: nil) }
      assert_response :success
      expect(user.reload.as_json).not_to be == old_user
    end

    it 'returns updated user' do
      patch user_url,
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: { user: attributes_for(:user, password: nil) }
      assert_response :success
      expect(json).to be == user.reload.as_json
    end
  end

  describe 'PATCH user#change_password' do
    let(:password) { Faker::Internet.password }
    let(:new_password) { Faker::Internet.password }
    let(:user) { create :user, password: password }

    it 'requires a valid token' do
      patch password_user_url
      assert_response :unauthorized
    end

    it 'requires current password' do
      patch password_user_url,
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: {
              user: { password: new_password,
                      password_confirmation: new_password }
            }
      assert_response :bad_request
      expect(user.reload.valid_password?(new_password)).to be false
    end

    it 'requires password confirmation' do
      patch password_user_url,
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: {
              user: { current_password: password, password: new_password }
            }
      assert_response :bad_request
      expect(user.reload.valid_password?(new_password)).to be false
    end

    it 'changes the user password' do
      patch password_user_url,
            headers: { 'Authorization' => "Bearer #{token.token}" },
            params: {
              user: { current_password: password,
                      password: new_password,
                      password_confirmation: new_password }
            }
      assert_response :success
      expect(user.reload.valid_password?(new_password)).to be true
    end
  end
end
