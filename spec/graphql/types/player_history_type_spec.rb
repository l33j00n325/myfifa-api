# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::PlayerHistoryType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:player_id).of_type('ID!') }
  it { is_expected.to have_field(:recorded_on).of_type('ISO8601Date!') }
  it { is_expected.to have_field(:ovr).of_type('Int!') }
  it { is_expected.to have_field(:value).of_type('Int!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:kit_no).of_type('Int') }

  it { is_expected.to have_field(:player).of_type('Player!') }
end
