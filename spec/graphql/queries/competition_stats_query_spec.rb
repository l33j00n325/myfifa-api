# frozen_string_literal: true

require 'rails_helper'

describe Types::QueryType, type: :graphql do
  subject(:field) { described_class.fields['competitionStats'] }

  it { is_expected.to accept_argument(:team_id).of_type('ID!') }
  it { is_expected.to accept_argument(:competition).of_type('String') }
  it { is_expected.to accept_argument(:season).of_type('String') }

  describe 'query competitionStats' do
    let(:user) { create :user }
    let(:team) { create :team, user: user }

    before do
      create_list :match, 10, team: team
    end

    graphql_operation <<-GQL
      query fetchCompetitionStats($teamId: ID!) {
        competitionStats(teamId: $teamId) {
          competition
          season
          wins
          draws
          losses
          goalsFor
          goalsAgainst
        }
      }
    GQL

    graphql_context do
      { current_user: user }
    end

    graphql_variables do
      { teamId: team.id }
    end

    it 'returns compiled Competition data' do
      compiled_stats = Statistics::CompetitionCompiler.new(team: team).results
      response_data['competitionStats'].each do |stats|
        stats = stats.transform_keys { |k| k.underscore.to_sym }
        expect(compiled_stats).to include(stats)
      end
    end
  end
end
