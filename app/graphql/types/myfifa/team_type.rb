# frozen_string_literal: true

module Types
  module Myfifa
    class TeamType < BaseObject
      field :id, ID, null: false
      field :user_id, ID, null: false
      field :name, String, null: false
      field :started_on, GraphQL::Types::ISO8601Date, null: false
      field :currently_on, GraphQL::Types::ISO8601Date, null: false
      field :active, Boolean, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :currency, String, null: false

      field :time_period, String, null: false
      field :badge_path, String, null: true
      field :opponents, [String], null: false

      field :players, [PlayerType], null: false
      field :matches, [MatchType], null: false
      field :competitions, [CompetitionType], null: false
      field :squads, [SquadType], null: false
    end
  end
end
