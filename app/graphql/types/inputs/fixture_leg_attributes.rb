# frozen_string_literal: true

module Types
  module Inputs
    class FixtureLegAttributes < BaseInputObject
      argument :id, ID, required: false
      argument :_destroy, Boolean, required: false
      argument :home_score, String, required: true
      argument :away_score, String, required: true
    end
  end
end
