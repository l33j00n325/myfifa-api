# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::GoalAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:minute).of_type('Int!') }
  it { is_expected.to accept_argument(:player_name).of_type('String') }
  it { is_expected.to accept_argument(:player_id).of_type('ID') }
  it { is_expected.to accept_argument(:assisted_by).of_type('String') }
  it { is_expected.to accept_argument(:assist_id).of_type('ID') }
  it { is_expected.to accept_argument(:home).of_type('Boolean') }
  it { is_expected.to accept_argument(:own_goal).of_type('Boolean') }
  it { is_expected.to accept_argument(:penalty).of_type('Boolean') }
end
