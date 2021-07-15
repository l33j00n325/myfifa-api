# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::FixtureLegAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:id).of_type('ID') }
  it { is_expected.to accept_argument(:_destroy).of_type('Boolean') }
  it { is_expected.to accept_argument(:home_score).of_type('String!') }
  it { is_expected.to accept_argument(:away_score).of_type('String!') }
end
