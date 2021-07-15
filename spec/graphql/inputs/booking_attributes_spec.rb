# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::BookingAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:minute).of_type('Int!') }
  it { is_expected.to accept_argument(:player_id).of_type('ID') }
  it { is_expected.to accept_argument(:red_card).of_type('Boolean') }
  it { is_expected.to accept_argument(:player_name).of_type('String') }
  it { is_expected.to accept_argument(:home).of_type('Boolean') }
end
