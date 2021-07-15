# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::TeamType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }

  it { is_expected.to have_field(:user_id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:started_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:currently_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:active).of_type('Boolean!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:currency).of_type('String!') }

  it { is_expected.to have_field(:time_period).of_type('String!') }
  it { is_expected.to have_field(:badge_path).of_type('String') }
  it { is_expected.to have_field(:opponents).of_type('[String!]!') }

  it { is_expected.to have_field(:players).of_type('[Player!]!') }
  it { is_expected.to have_field(:matches).of_type('[Match!]!') }
  it { is_expected.to have_field(:competitions).of_type('[Competition!]!') }
  it { is_expected.to have_field(:squads).of_type('[Squad!]!') }
end
