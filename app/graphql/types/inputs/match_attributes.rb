# frozen_string_literal: true

module Types
  module Inputs
    class MatchAttributes < BaseInputObject
      argument :home, String, required: false
      argument :away, String, required: false
      argument :competition, String, required: false
      argument :played_on, GraphQL::Types::ISO8601Date, required: false
      argument :extra_time, Boolean, required: false
      argument :stage, String, required: false

      argument :penalty_shootout_attributes,
               PenaltyShootoutAttributes,
               required: false
    end
  end
end
