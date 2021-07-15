# frozen_string_literal: true

module Types
  module Myfifa
    class TransferType < BaseObject
      field :id, ID, null: false
      field :player_id, ID, null: false
      field :signed_on, GraphQL::Types::ISO8601Date, null: false
      field :moved_on, GraphQL::Types::ISO8601Date, null: false
      field :origin, String, null: false
      field :destination, String, null: false
      field :fee, Integer, null: true
      field :traded_player, String, null: true
      field :addon_clause, Integer, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :player, PlayerType, null: false
    end
  end
end
