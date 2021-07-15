# frozen_string_literal: true

module Types
  class QueryType < BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :teams, [Myfifa::TeamType], null: false
    field :team, Myfifa::TeamType, null: false do
      argument :id, ID, required: true
    end
    field :player, Myfifa::PlayerType, null: false do
      argument :id, ID, required: true
    end
    field :match, Myfifa::MatchType, null: false do
      argument :id, ID, required: true
    end
    field :competition, Myfifa::CompetitionType, null: false do
      argument :id, ID, required: true
    end
    field :player_stats, [Statistics::PlayerStatsType], null: false do
      argument :team_id, ID, required: true
      argument :player_id, ID, required: false
      argument :competition, String, required: false
      argument :season, String, required: false
    end
    field :competition_stats, [Statistics::CompetitionStatsType], null: false do
      argument :team_id, ID, required: true
      argument :competition, String, required: false
      argument :season, String, required: false
    end

    def teams
      Team.accessible_by(current_ability).all
    end

    def team(id:)
      Team.accessible_by(current_ability).find(id)
    end

    def player(id:)
      Player.accessible_by(current_ability).find(id)
    end

    def match(id:)
      Match.accessible_by(current_ability).find(id)
    end

    def competition(id:)
      Competition.accessible_by(current_ability).find(id)
    end

    def player_stats(team_id:, player_id: nil, competition: nil, season: nil)
      team = Team.accessible_by(current_ability).find(team_id)
      ::Statistics::PlayerCompiler.new(
        team: team,
        player_id: player_id,
        competition: competition,
        season: season
      ).results
    end

    def competition_stats(team_id:, competition: nil, season: nil)
      team = Team.accessible_by(current_ability).find(team_id)
      ::Statistics::CompetitionCompiler.new(
        team: team,
        competition: competition,
        season: season
      ).results
    end

    private

      def current_ability
        Ability.new(context[:current_user])
      end
  end
end
