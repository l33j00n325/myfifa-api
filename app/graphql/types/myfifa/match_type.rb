# frozen_string_literal: true

module Types
  module Myfifa
    class MatchType < BaseObject
      field :id, ID, null: false
      field :team_id, ID, null: false
      field :home, String, null: false
      field :away, String, null: false
      field :competition, String, null: true
      field :season, Integer, null: false
      field :played_on, GraphQL::Types::ISO8601Date, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :extra_time, Boolean, null: false
      field :home_score, Integer, null: false
      field :away_score, Integer, null: false
      field :stage, String, null: true
      field :friendly, Boolean, null: false

      field :score, String, null: false
      field :team_result, String, null: false

      field :team, TeamType, null: false
      field :caps, [CapType], null: false
      field :goals, [GoalType], null: false
      field :substitutions, [SubstitutionType], null: false
      field :bookings, [BookingType], null: false
      field :penalty_shootout, PenaltyShootoutType, null: true
    end
  end
end
