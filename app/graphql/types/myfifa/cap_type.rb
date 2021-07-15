# frozen_string_literal: true

module Types
  module Myfifa
    class CapType < BaseObject
      field :id, ID, null: false
      field :match_id, ID, null: false
      field :player_id, ID, null: false
      field :pos, String, null: false
      field :start, Integer, null: false
      field :stop, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :subbed_out, Boolean, null: false
      field :rating, Integer, null: true

      field :match, MatchType, null: false
      field :player, PlayerType, null: false
    end
  end
end
