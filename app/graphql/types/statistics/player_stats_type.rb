# frozen_string_literal: true

module Types
  module Statistics
    class PlayerStatsType < BaseObject
      field :player_id, ID, null: false
      field :season, Integer, null: false
      field :competition, String, null: false
      field :num_matches, Integer, null: false
      field :num_minutes, Integer, null: false
      field :num_goals, Integer, null: false
      field :num_assists, Integer, null: false
      field :num_clean_sheets, Integer, null: false
    end
  end
end
