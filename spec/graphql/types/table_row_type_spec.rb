# frozen_string_literal: true

require 'rails_helper'

describe Types::Myfifa::TableRowType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:stage_id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String') }
  it { is_expected.to have_field(:wins).of_type('Int') }
  it { is_expected.to have_field(:draws).of_type('Int') }
  it { is_expected.to have_field(:losses).of_type('Int') }
  it { is_expected.to have_field(:goals_for).of_type('Int') }
  it { is_expected.to have_field(:goals_against).of_type('Int') }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }

  it { is_expected.to have_field(:goal_difference).of_type('Int!') }
  it { is_expected.to have_field(:points).of_type('Int!') }

  it { is_expected.to have_field(:stage).of_type('Stage!') }
end
