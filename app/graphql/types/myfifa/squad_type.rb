# frozen_string_literal: true

module Types
  module Myfifa
    class SquadType < BaseObject
      field :id, ID, null: false
      field :team_id, ID, null: false
      field :name, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :team, TeamType, null: false
      field :squad_players, [SquadPlayerType], null: false
    end
  end
end
