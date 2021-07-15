# frozen_string_literal: true

module Types
  module Myfifa
    class LoanType < BaseObject
      field :id, ID, null: false
      field :player_id, ID, null: false
      field :started_on, GraphQL::Types::ISO8601Date, null: false
      field :ended_on, GraphQL::Types::ISO8601Date, null: true
      field :destination, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :origin, String, null: false
      field :signed_on, GraphQL::Types::ISO8601Date, null: false
      field :wage_percentage, Integer, null: true

      field :player, PlayerType, null: false
    end
  end
end
