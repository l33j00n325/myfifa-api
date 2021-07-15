# frozen_string_literal: true

module Types
  module Inputs
    class ContractAttributes < BaseInputObject
      argument :wage, Integer, required: true
      argument :signing_bonus, Integer, required: false
      argument :release_clause, Integer, required: false
      argument :performance_bonus, Integer, required: false
      argument :bonus_req, Integer, required: false
      argument :bonus_req_type, String, required: false
      argument :ended_on, GraphQL::Types::ISO8601Date, required: true
      argument :started_on, GraphQL::Types::ISO8601Date, required: true

      argument :num_seasons, Integer, required: false
    end
  end
end
