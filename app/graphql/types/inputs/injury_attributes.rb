# frozen_string_literal: true

module Types
  module Inputs
    class InjuryAttributes < BaseInputObject
      argument :started_on, GraphQL::Types::ISO8601Date, required: false
      argument :ended_on, GraphQL::Types::ISO8601Date, required: false
      argument :description, String, required: true

      argument :recovered, Boolean, required: false
    end
  end
end
