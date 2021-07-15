# frozen_string_literal: true

module Types
  module Myfifa
    class FixtureLegType < BaseObject
      field :id, ID, null: false
      field :fixture_id, ID, null: false
      field :home_score, String, null: true
      field :away_score, String, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :fixture, FixtureType, null: false
    end
  end
end
