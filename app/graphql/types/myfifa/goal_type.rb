# frozen_string_literal: true

module Types
  module Myfifa
    class GoalType < BaseObject
      field :id, ID, null: false
      field :match_id, ID, null: false
      field :minute, Integer, null: false
      field :player_name, String, null: false
      field :player_id, ID, null: true
      field :assist_id, ID, null: true
      field :home, Boolean, null: false
      field :own_goal, Boolean, null: false
      field :penalty, Boolean, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :assisted_by, String, null: true

      field :player, PlayerType, null: true
      field :assisting_player, PlayerType, null: true
    end
  end
end
