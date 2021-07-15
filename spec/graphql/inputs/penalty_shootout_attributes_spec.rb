# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::PenaltyShootoutAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:home_score).of_type('Int!') }
  it { is_expected.to accept_argument(:away_score).of_type('Int!') }
end
