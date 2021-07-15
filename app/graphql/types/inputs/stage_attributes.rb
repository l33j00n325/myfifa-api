# frozen_string_literal: true

module Types
  module Inputs
    class StageAttributes < BaseInputObject
      argument :name, String, required: false
      argument :num_teams, Integer, required: false
      argument :num_fixtures, Integer, required: false
      argument :table, Boolean, required: false
    end
  end
end
