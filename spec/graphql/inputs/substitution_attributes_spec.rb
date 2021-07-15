# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::SubstitutionAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:minute).of_type('Int!') }
  it { is_expected.to accept_argument(:player_id).of_type('ID!') }
  it { is_expected.to accept_argument(:replacement_id).of_type('ID!') }
  it { is_expected.to accept_argument(:injury).of_type('Boolean') }
end
