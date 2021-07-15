# frozen_string_literal: true

module Types
  module Myfifa
    class PenaltyShootoutType < BaseObject
      field :id, ID, null: false
      field :match_id, ID, null: false
      field :home_score, Integer, null: false
      field :away_score, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :match, MatchType, null: false
    end
  end
end
