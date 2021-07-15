# frozen_string_literal: true

module Types
  module Inputs
    class TransferAttributes < BaseInputObject
      argument :moved_on, GraphQL::Types::ISO8601Date, required: false
      argument :origin, String, required: false
      argument :destination, String, required: false
      argument :fee, Integer, required: false
      argument :traded_player, String, required: false
      argument :addon_clause, Integer, required: false
    end
  end
end
