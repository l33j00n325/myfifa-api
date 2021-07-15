# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::PlayerType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:team_id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:nationality).of_type('String') }
  it { is_expected.to have_field(:pos).of_type('String!') }
  it { is_expected.to have_field(:sec_pos).of_type('[String!]!') }
  it { is_expected.to have_field(:ovr).of_type('Int!') }
  it { is_expected.to have_field(:value).of_type('Int!') }
  it { is_expected.to have_field(:birth_year).of_type('Int!') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:status).of_type('String') }
  it { is_expected.to have_field(:youth).of_type('Boolean!') }
  it { is_expected.to have_field(:kit_no).of_type('Int') }

  it { is_expected.to have_field(:age).of_type('Int!') }

  it { is_expected.to have_field(:team).of_type('Team!') }

  it { is_expected.to have_field(:histories).of_type('[PlayerHistory!]!') }
  it { is_expected.to have_field(:injuries).of_type('[Injury!]!') }
  it { is_expected.to have_field(:loans).of_type('[Loan!]!') }
  it { is_expected.to have_field(:contracts).of_type('[Contract!]!') }
  it { is_expected.to have_field(:transfers).of_type('[Transfer!]!') }

  it { is_expected.to have_field(:caps).of_type('[Cap!]!') }
  it { is_expected.to have_field(:goals).of_type('[Goal!]!') }
  it { is_expected.to have_field(:assists).of_type('[Goal!]!') }
  it { is_expected.to have_field(:bookings).of_type('[Booking!]!') }
end
