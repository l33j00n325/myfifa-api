# frozen_string_literal: true

module Types
  module Inputs
    class TeamAttributes < BaseInputObject
      argument :name, String, required: false
      argument :started_on, GraphQL::Types::ISO8601Date, required: false
      argument :currently_on, GraphQL::Types::ISO8601Date, required: false
      argument :active, Boolean, required: false
      argument :currency, String, required: false
    end
  end
end
