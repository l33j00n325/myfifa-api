# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::ContractType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:signed_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:wage).of_type('Int!') }
  it { is_expected.to have_field(:signing_bonus).of_type('Int') }
  it { is_expected.to have_field(:release_clause).of_type('Int') }
  it { is_expected.to have_field(:performance_bonus).of_type('Int') }
  it { is_expected.to have_field(:bonus_req).of_type('Int') }
  it { is_expected.to have_field(:bonus_req_type).of_type('String') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:ended_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:started_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:conclusion).of_type('String') }

  it { is_expected.to have_field(:player).of_type('Player!') }
end
