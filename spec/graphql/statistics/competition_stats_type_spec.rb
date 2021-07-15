# frozen_string_literal: true

require 'rails_helper'

describe Types::Statistics::CompetitionStatsType do
  subject { described_class }

  it { is_expected.to have_field(:competition).of_type('String!') }
  it { is_expected.to have_field(:season).of_type('Int!') }
  it { is_expected.to have_field(:wins).of_type('Int!') }
  it { is_expected.to have_field(:draws).of_type('Int!') }
  it { is_expected.to have_field(:losses).of_type('Int!') }
  it { is_expected.to have_field(:goals_for).of_type('Int!') }
  it { is_expected.to have_field(:goals_against).of_type('Int!') }
end
