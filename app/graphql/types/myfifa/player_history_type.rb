# frozen_string_literal: true

module Types
  module Myfifa
    class PlayerHistoryType < BaseObject
      field :id, ID, null: false
      field :player_id, ID, null: false
      field :recorded_on, GraphQL::Types::ISO8601Date, null: false
      field :ovr, Integer, null: false
      field :value, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :kit_no, Integer, null: true

      field :player, PlayerType, null: false
    end
  end
end
