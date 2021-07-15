# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::MatchType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:team_id).of_type('ID!') }
  it { is_expected.to have_field(:home).of_type('String!') }
  it { is_expected.to have_field(:away).of_type('String!') }
  it { is_expected.to have_field(:competition).of_type('String') }
  it { is_expected.to have_field(:season).of_type('Int!') }
  it { is_expected.to have_field(:played_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:extra_time).of_type('Boolean!') }
  it { is_expected.to have_field(:home_score).of_type('Int!') }
  it { is_expected.to have_field(:away_score).of_type('Int!') }
  it { is_expected.to have_field(:stage).of_type('String') }
  it { is_expected.to have_field(:friendly).of_type('Boolean!') }

  it { is_expected.to have_field(:score).of_type('String!') }
  it { is_expected.to have_field(:team_result).of_type('String!') }

  it { is_expected.to have_field(:team).of_type('Team!') }
  it { is_expected.to have_field(:caps).of_type('[Cap!]!') }
  it { is_expected.to have_field(:goals).of_type('[Goal!]!') }
  it { is_expected.to have_field(:substitutions).of_type('[Substitution!]!') }
  it { is_expected.to have_field(:bookings).of_type('[Booking!]!') }
  it { is_expected.to have_field(:penalty_shootout).of_type('PenaltyShootout') }
end
