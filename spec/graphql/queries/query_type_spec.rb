# frozen_string_literal: true

require 'rails_helper'

describe Types::QueryType do
  subject { described_class }

  it { is_expected.to have_field(:teams).of_type('[Team!]!') }
  it { is_expected.to have_field(:team).of_type('Team!') }
  it { is_expected.to have_field(:player).of_type('Player!') }
  it { is_expected.to have_field(:match).of_type('Match!') }
  it { is_expected.to have_field(:competition).of_type('Competition!') }

  it { is_expected.to have_field(:competition_stats).of_type('[CompetitionStats!]!') }
  it { is_expected.to have_field(:player_stats).of_type('[PlayerStats!]!') }
end
