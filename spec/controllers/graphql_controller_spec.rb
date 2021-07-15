# frozen_string_literal: true

require 'rails_helper'

describe GraphqlController, type: :request do
  let(:user) { create :user }
  let(:application) do
    Doorkeeper::Application.create! name: Faker::Company.name,
                                    redirect_uri: "https://#{Faker::Internet.domain_name}"
  end
  let(:token) do
    Doorkeeper::AccessToken.create! application: application,
                                    resource_owner_id: user.id
  end

  describe 'POST graphql#execute' do
    it 'parses and executes gql' do
      post graphql_url,
           params: { query: GraphQL::Introspection::INTROSPECTION_QUERY }
      expect(json['data']).to be_present
    end

    describe 'with fetchTeam query' do
      let(:team) { create :team, user: user }

      team_query = <<-GQL
        query fetchTeam($id: ID!) {
          team(id: $id) {
            id
            name
          }
        }
      GQL

      it 'parses variables as JSON' do
        post graphql_url,
             headers: { 'Authorization' => "Bearer #{token.token}" },
             params: { query: team_query, variables: { id: team.id }.to_json }
        expect(json.dig('data', 'team')).to be_present
      end

      it 'parses variables as hash' do
        post graphql_url,
             headers: { 'Authorization' => "Bearer #{token.token}" },
             params: { query: team_query, variables: { id: team.id } }
        expect(json.dig('data', 'team')).to be_present
      end
    end
  end
end
