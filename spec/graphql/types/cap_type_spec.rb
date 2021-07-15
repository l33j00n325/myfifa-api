# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::CapType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:match_id).of_type('ID!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:pos).of_type('String!') }
  it { is_expected.to have_field(:start).of_type('Int!') }
  it { is_expected.to have_field(:stop).of_type('Int!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:subbed_out).of_type('Boolean!') }
  it { is_expected.to have_field(:rating).of_type('Int') }

  it { is_expected.to have_field(:match).of_type('Match!') }
  it { is_expected.to have_field(:player).of_type('Player!') }
end
