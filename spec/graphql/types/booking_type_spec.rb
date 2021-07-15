# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::BookingType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:match_id).of_type('ID!') }
  it { is_expected.to have_field(:minute).of_type('Int!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:red_card).of_type('Boolean!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:player_name).of_type('String!') }
  it { is_expected.to have_field(:home).of_type('Boolean!') }

  it { is_expected.to have_field(:match).of_type('Match!') }
  it { is_expected.to have_field(:player).of_type('Player!') }
end
