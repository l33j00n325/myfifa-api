# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::InjuryAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:started_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:ended_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:description).of_type('String!') }

  it { is_expected.to accept_argument(:recovered).of_type('Boolean') }
end
