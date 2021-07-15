# frozen_string_literal: true

module Types
  module Inputs
    class LoanAttributes < BaseInputObject
      argument :started_on, GraphQL::Types::ISO8601Date, required: true
      argument :ended_on, GraphQL::Types::ISO8601Date, required: false
      argument :destination, String, required: true
      argument :origin, String, required: true
      argument :wage_percentage, Integer, required: false

      argument :returned, Boolean, required: false
    end
  end
end
