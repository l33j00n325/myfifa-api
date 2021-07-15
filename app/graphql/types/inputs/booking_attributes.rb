# frozen_string_literal: true

module Types
  module Inputs
    class BookingAttributes < BaseInputObject
      argument :minute, Integer, required: true
      argument :player_id, ID, required: false
      argument :red_card, Boolean, required: false
      argument :player_name, String, required: false
      argument :home, Boolean, required: false
    end
  end
end
