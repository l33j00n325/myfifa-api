# frozen_string_literal: true

module Types
  module Statistics
    class CompetitionStatsType < BaseObject
      field :season, Integer, null: false
      field :competition, String, null: false
      field :wins, Integer, null: false
      field :draws, Integer, null: false
      field :losses, Integer, null: false
      field :goals_for, Integer, null: false
      field :goals_against, Integer, null: false
    end
  end
end
