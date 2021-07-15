# frozen_string_literal: true

module Types
  module Inputs
    class CompetitionAttributes < BaseInputObject
      argument :season, Integer, required: false
      argument :name, String, required: false
      argument :champion, String, required: false

      argument :preset_format, String, required: false
      argument :num_teams, Integer, required: false
      argument :num_teams_per_group, Integer, required: false
      argument :num_advances_from_group, Integer, required: false
    end
  end
end
