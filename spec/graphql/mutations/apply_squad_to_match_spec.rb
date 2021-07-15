# frozen_string_literal: true

require 'rails_helper'

describe Mutations::ApplySquadToMatch, type: :graphql do
  subject { described_class }

  let(:user) { create :user }
  let(:team) { create :team, user: user }
  let(:match) { create :match, team: team }
  let(:squad) { create :squad, team: team }

  it { is_expected.to accept_argument(:match_id).of_type('ID!') }
  it { is_expected.to accept_argument(:squad_id).of_type('ID!') }
  it { is_expected.to have_a_field(:match).returning('Match!') }

  graphql_operation <<-GQL
    mutation applySquadToMatch($matchId: ID!, $squadId: ID!) {
      applySquadToMatch(matchId: $matchId, squadId: $squadId) {
        match { id }
      }
    }
  GQL

  graphql_variables do
    {
      matchId: match.id,
      squadId: squad.id
    }
  end

  graphql_context do
    { current_user: user }
  end

  it 'populates Match caps based on Squad players' do
    execute_graphql
    expect(match.caps.pluck(:player_id))
      .to be == squad.squad_players.pluck(:player_id)
  end

  it 'populates Match caps based on Squad positions' do
    execute_graphql
    expect(match.caps.pluck(:pos))
      .to be == squad.squad_players.pluck(:pos)
  end

  it 'returns the affected Squad' do
    expect(response_data.dig('applySquadToMatch', 'match', 'id'))
      .to be == match.id.to_s
  end
end
