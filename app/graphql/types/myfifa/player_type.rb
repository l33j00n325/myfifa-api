# frozen_string_literal: true

module Types
  module Myfifa
    class PlayerType < BaseObject
      field :id, ID, null: false
      field :team_id, ID, null: false
      field :name, String, null: false
      field :nationality, String, null: true
      field :pos, String, null: false
      field :sec_pos, [String], null: false
      field :ovr, Integer, null: false
      field :value, Integer, null: false
      field :birth_year, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :status, String, null: true
      field :youth, Boolean, null: false
      field :kit_no, Integer, null: true

      field :age, Integer, null: false

      field :team, TeamType, null: false

      field :histories, [PlayerHistoryType], null: false
      field :injuries, [InjuryType], null: false
      field :loans, [LoanType], null: false
      field :contracts, [ContractType], null: false
      field :transfers, [TransferType], null: false

      field :caps, [CapType], null: false
      field :goals, [GoalType], null: false
      field :assists, [GoalType], null: false
      field :bookings, [BookingType], null: false
    end
  end
end
