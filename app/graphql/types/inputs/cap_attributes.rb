# frozen_string_literal: true

module Types
  module Inputs
    class CapAttributes < BaseInputObject
      argument :player_id, ID, required: false
      argument :pos, String, required: false
    end
  end
end
