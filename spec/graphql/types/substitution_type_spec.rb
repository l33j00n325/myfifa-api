# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::SubstitutionType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:match_id).of_type('ID!') }
  it { is_expected.to have_field(:minute).of_type('Int!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:replacement_id).of_type('ID!') }
  it { is_expected.to have_field(:injury).of_type('Boolean!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:player_name).of_type('String!') }
  it { is_expected.to have_field(:replaced_by).of_type('String!') }

  it { is_expected.to have_field(:player).of_type('Player!') }
  it { is_expected.to have_field(:replacement).of_type('Player!') }
end
