# frozen_string_literal: true

module Types
  module Inputs
    class PenaltyShootoutAttributes < BaseInputObject
      argument :home_score, Integer, required: true
      argument :away_score, Integer, required: true
    end
  end
end
