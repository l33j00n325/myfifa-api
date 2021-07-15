# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::MatchAttributes do
  subject(:match_attributes) { described_class }

  it { is_expected.to accept_argument(:home).of_type('String') }
  it { is_expected.to accept_argument(:away).of_type('String') }
  it { is_expected.to accept_argument(:competition).of_type('String') }
  it { is_expected.to accept_argument(:played_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:extra_time).of_type('Boolean') }
  it { is_expected.to accept_argument(:stage).of_type('String') }

  it do
    expect(match_attributes).to(
      accept_argument(:penalty_shootout_attributes)
        .of_type('PenaltyShootoutAttributes')
    )
  end
end
