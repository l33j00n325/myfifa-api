# frozen_string_literal: true

module Types
  module Inputs
    class FixtureAttributes < BaseInputObject
      argument :home_team, String, required: true
      argument :away_team, String, required: true

      argument :legs_attributes, [FixtureLegAttributes], required: true
    end
  end
end
