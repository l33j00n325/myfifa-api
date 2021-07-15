# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::SquadPlayerType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:squad_id).of_type('ID!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:pos).of_type('String!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:squad).of_type('Squad!') }
  it { is_expected.to have_field(:player).of_type('Player!') }
end
