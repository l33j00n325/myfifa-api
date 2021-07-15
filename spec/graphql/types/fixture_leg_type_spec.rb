# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::FixtureLegType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:fixture_id).of_type('ID!') }
  it { is_expected.to have_field(:home_score).of_type('String') }
  it { is_expected.to have_field(:away_score).of_type('String') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:fixture).of_type('Fixture!') }
end
