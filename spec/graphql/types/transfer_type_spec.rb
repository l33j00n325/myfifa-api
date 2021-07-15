# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::TransferType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:signed_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:moved_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:origin).of_type('String!') }
  it { is_expected.to have_field(:destination).of_type('String!') }
  it { is_expected.to have_field(:fee).of_type('Int') }
  it { is_expected.to have_field(:traded_player).of_type('String') }
  it { is_expected.to have_field(:addon_clause).of_type('Int') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:player).of_type('Player!') }
end
