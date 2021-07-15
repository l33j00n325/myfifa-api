# frozen_string_literal: true

module Types
  module Inputs
    class SquadAttributes < BaseInputObject
      argument :name, String, required: true

      argument :squad_players_attributes,
               [SquadPlayerAttributes],
               required: true
    end
  end
end
