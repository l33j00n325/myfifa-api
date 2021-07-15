# frozen_string_literal: true

require 'rails_helper'

describe Types::QueryType, type: :graphql do
  subject(:field) { described_class.fields['playerStats'] }

  it { is_expected.to accept_argument(:team_id).of_type('ID!') }
  it { is_expected.to accept_argument(:player_id).of_type('ID') }
  it { is_expected.to accept_argument(:competition).of_type('String') }
  it { is_expected.to accept_argument(:season).of_type('String') }

  describe 'query playerStats' do
    let(:user) { create :user }
    let(:team) { create :team, user: user }

    graphql_operation <<-GQL
      query fetchPlayerStats($teamId: ID!) {
        playerStats(teamId: $teamId) {
          playerId
          competition
          season
          numMatches
          numMinutes
          numGoals
          numAssists
          numCleanSheets
        }
      }
    GQL

    graphql_context do
      { current_user: user }
    end

    graphql_variables do
      { teamId: team.id }
    end

    before do
      players = create_list :player, 3, team: team
      matches = create_list :match, 3, team: team
      create_list :goal, 3, player: players.sample, match: matches.sample
      matches.each do |match|
        players.each do |player|
          create :cap, player: player, match: match
        end
      end
    end

    it 'returns compiled Player data' do
      compiled_stats = Statistics::PlayerCompiler.new(team: team).results
      response_data['playerStats'].each do |stats|
        stats = stats.transform_keys { |k| k.underscore.to_sym }
        stats[:player_id] = stats[:player_id].to_i
        expect(compiled_stats).to include(stats)
      end
    end
  end
end
