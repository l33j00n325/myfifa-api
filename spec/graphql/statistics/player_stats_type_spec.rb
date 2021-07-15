# frozen_string_literal: true

require 'rails_helper'

describe Types::Statistics::PlayerStatsType do
  subject { described_class }

  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:competition).of_type('String!') }
  it { is_expected.to have_field(:season).of_type('Int!') }
  it { is_expected.to have_field(:num_matches).of_type('Int!') }
  it { is_expected.to have_field(:num_minutes).of_type('Int!') }
  it { is_expected.to have_field(:num_goals).of_type('Int!') }
  it { is_expected.to have_field(:num_assists).of_type('Int!') }
  it { is_expected.to have_field(:num_clean_sheets).of_type('Int!') }
end
