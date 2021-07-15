# frozen_string_literal: true

module Types
  module Inputs
    class PlayerAttributes < BaseInputObject
      argument :name, String, required: false
      argument :nationality, String, required: false
      argument :pos, String, required: false
      argument :sec_pos, [String], required: false
      argument :ovr, Integer, required: false
      argument :value, Integer, required: false
      argument :youth, Boolean, required: false
      argument :kit_no, Integer, required: false

      argument :age, Integer, required: false

      argument :contracts_attributes, [ContractAttributes], required: false
    end
  end
end
