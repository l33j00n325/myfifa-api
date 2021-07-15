# frozen_string_literal: true

module Types
  module Myfifa
    class ContractType < BaseObject
      field :id, ID, null: false
      field :player_id, ID, null: false
      field :signed_on, GraphQL::Types::ISO8601Date, null: false
      field :wage, Integer, null: false
      field :signing_bonus, Integer, null: true
      field :release_clause, Integer, null: true
      field :performance_bonus, Integer, null: true
      field :bonus_req, Integer, null: true
      field :bonus_req_type, String, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :ended_on, GraphQL::Types::ISO8601Date, null: false
      field :started_on, GraphQL::Types::ISO8601Date, null: false
      field :conclusion, String, null: true

      field :player, PlayerType, null: false
    end
  end
end
