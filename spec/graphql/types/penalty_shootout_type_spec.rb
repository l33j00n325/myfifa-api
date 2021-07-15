# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::PenaltyShootoutType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:match_id).of_type('ID!') }
  it { is_expected.to have_field(:home_score).of_type('Int!') }
  it { is_expected.to have_field(:away_score).of_type('Int!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:match).of_type('Match!') }
end
