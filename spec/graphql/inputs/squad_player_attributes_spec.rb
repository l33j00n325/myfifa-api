# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::SquadPlayerAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:id).of_type('ID') }
  it { is_expected.to accept_argument(:player_id).of_type('ID!') }
  it { is_expected.to accept_argument(:pos).of_type('String!') }
end
