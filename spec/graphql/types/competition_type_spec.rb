# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::CompetitionType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:team_id).of_type('ID!') }
  it { is_expected.to have_field(:season).of_type('Int!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:champion).of_type('String') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:team).of_type('Team!') }
  it { is_expected.to have_field(:stages).of_type('[Stage!]!') }
end
