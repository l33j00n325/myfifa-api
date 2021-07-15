# frozen_string_literal: true

module Types
  module Inputs
    class GoalAttributes < BaseInputObject
      argument :minute, Integer, required: true
      argument :player_name, String, required: false
      argument :player_id, ID, required: false
      argument :assisted_by, String, required: false
      argument :assist_id, ID, required: false
      argument :home, Boolean, required: false
      argument :own_goal, Boolean, required: false
      argument :penalty, Boolean, required: false
    end
  end
end
