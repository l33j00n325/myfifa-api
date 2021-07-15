# frozen_string_literal: true

module Types
  module Inputs
    class TableRowAttributes < BaseInputObject
      argument :name, String, required: false
      argument :wins, Integer, required: false
      argument :draws, Integer, required: false
      argument :losses, Integer, required: false
      argument :goals_for, Integer, required: false
      argument :goals_against, Integer, required: false
    end
  end
end
