# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::StageType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:competition_id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:num_teams).of_type('Int') }
  it { is_expected.to have_field(:num_fixtures).of_type('Int') }
  it { is_expected.to have_field(:table).of_type('Boolean!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:competition).of_type('Competition!') }
  it { is_expected.to have_field(:table_rows).of_type('[TableRow!]!') }
  it { is_expected.to have_field(:fixtures).of_type('[Fixture!]!') }
end
