# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::GoalType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:match_id).of_type('ID!') }
  it { is_expected.to have_field(:minute).of_type('Int!') }
  it { is_expected.to have_field(:player_name).of_type('String!') }
  it { is_expected.to have_field(:player_id).of_type('ID') }
  it { is_expected.to have_field(:assist_id).of_type('ID') }
  it { is_expected.to have_field(:home).of_type('Boolean!') }
  it { is_expected.to have_field(:own_goal).of_type('Boolean!') }
  it { is_expected.to have_field(:penalty).of_type('Boolean!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:assisted_by).of_type('String') }

  it { is_expected.to have_field(:player).of_type('Player') }
  it { is_expected.to have_field(:assisting_player).of_type('Player') }
end
