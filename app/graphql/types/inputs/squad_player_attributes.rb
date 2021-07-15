# frozen_string_literal: true

module Types
  module Inputs
    class SquadPlayerAttributes < BaseInputObject
      argument :id, ID, required: false
      argument :player_id, ID, required: true
      argument :pos, String, required: true
    end
  end
end
