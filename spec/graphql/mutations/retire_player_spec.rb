# frozen_string_literal: true

require 'rails_helper'

describe Mutations::RetirePlayer, type: :graphql do
  subject { described_class }

  let(:user) { create :user }
  let(:player) do
    team = create :team, user: user
    create :player, team: team
  end

  it { is_expected.to accept_argument(:id).of_type('ID!') }
  it { is_expected.to have_a_field(:player).returning('Player!') }

  graphql_operation <<-GQL
    mutation retirePlayer($id: ID!) {
      retirePlayer(id: $id) {
        player { id }
      }
    }
  GQL

  graphql_variables do
    { id: player.id }
  end

  graphql_context do
    { current_user: user }
  end

  it 'updates the Player contract as Retiring' do
    execute_graphql
    expect(player.last_contract.conclusion).to be == 'Retired'
  end

  it 'returns the affected Player' do
    expect(response_data.dig('retirePlayer', 'player', 'id'))
      .to be == player.id.to_s
  end

  it 'does not release a Player not owned by user' do
    player = create :player
    execute_graphql
    expect(player.last_contract.conclusion).not_to be == 'Retired'
  end
end
