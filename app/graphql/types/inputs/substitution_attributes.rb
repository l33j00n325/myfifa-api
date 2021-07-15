# frozen_string_literal: true

module Types
  module Inputs
    class SubstitutionAttributes < BaseInputObject
      argument :minute, Integer, required: true
      argument :player_id, ID, required: true
      argument :replacement_id, ID, required: true
      argument :injury, Boolean, required: false
    end
  end
end
