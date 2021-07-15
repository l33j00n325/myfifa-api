# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::TeamAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:name).of_type('String') }
  it { is_expected.to accept_argument(:started_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:currently_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:active).of_type('Boolean') }
  it { is_expected.to accept_argument(:currency).of_type('String') }
end
