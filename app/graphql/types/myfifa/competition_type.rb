# frozen_string_literal: true

module Types
  module Myfifa
    class CompetitionType < BaseObject
      field :id, ID, null: false
      field :team_id, ID, null: false
      field :season, Integer, null: false
      field :name, String, null: false
      field :champion, String, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :team, TeamType, null: false
      field :stages, [StageType], null: false
    end
  end
end
