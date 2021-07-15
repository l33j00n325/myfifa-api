# frozen_string_literal: true

module Types
  module Myfifa
    class FixtureType < BaseObject
      field :id, ID, null: false
      field :stage_id, ID, null: false
      field :home_team, String, null: true
      field :away_team, String, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :stage, StageType, null: false
      field :legs, [FixtureLegType], null: false
    end
  end
end
