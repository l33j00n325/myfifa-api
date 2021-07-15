# frozen_string_literal: true

module Types
  module Myfifa
    class SubstitutionType < BaseObject
      field :id, ID, null: false
      field :match_id, ID, null: false
      field :minute, Integer, null: false
      field :player_id, ID, null: false
      field :replacement_id, ID, null: false
      field :injury, Boolean, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :player_name, String, null: false
      field :replaced_by, String, null: false

      field :player, PlayerType, null: false
      field :replacement, PlayerType, null: false
    end
  end
end
