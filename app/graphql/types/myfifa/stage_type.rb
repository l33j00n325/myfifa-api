# frozen_string_literal: true

module Types
  module Myfifa
    class StageType < BaseObject
      field :id, ID, null: false
      field :competition_id, ID, null: false
      field :name, String, null: false
      field :num_teams, Integer, null: true
      field :num_fixtures, Integer, null: true
      field :table, Boolean, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :competition, CompetitionType, null: false
      field :table_rows, [TableRowType], null: false
      field :fixtures, [FixtureType], null: false
    end
  end
end
