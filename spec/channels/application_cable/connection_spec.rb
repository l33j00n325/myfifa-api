# frozen_string_literal: true

require 'rails_helper'

describe ApplicationCable::Connection, type: :channel do
  let(:user) { create :user }
  let(:application) do
    Doorkeeper::Application.create! name: Faker::Company.name,
                                    redirect_uri: "https://#{Faker::Internet.domain_name}"
  end
  let(:token) do
    Doorkeeper::AccessToken.create! application: application,
                                    resource_owner_id: user.id
  end

  it 'successfully connects with token' do
    connect '/cable', params: { access_token: token.token }
    expect(connection.current_user).to be == user
  end

  it 'rejects connection without token' do
    expect { connect '/cable' }.to have_rejected_connection
  end
end
