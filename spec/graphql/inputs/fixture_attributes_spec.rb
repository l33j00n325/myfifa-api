# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::FixtureAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:home_team).of_type('String!') }
  it { is_expected.to accept_argument(:away_team).of_type('String!') }
  it { is_expected.to accept_argument(:legs_Attributes).of_type('[FixtureLegAttributes!]!') }
end
