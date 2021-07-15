# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::FixtureType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:stage_id).of_type('ID!') }
  it { is_expected.to have_field(:home_team).of_type('String') }
  it { is_expected.to have_field(:away_team).of_type('String') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:stage).of_type('Stage!') }
  it { is_expected.to have_field(:legs).of_type('[FixtureLeg!]!') }
end
