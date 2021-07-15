# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::TransferAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:moved_on).of_type('ISO8601Date') }
  it { is_expected.to accept_argument(:origin).of_type('String') }
  it { is_expected.to accept_argument(:destination).of_type('String') }
  it { is_expected.to accept_argument(:fee).of_type('Int') }
  it { is_expected.to accept_argument(:traded_player).of_type('String') }
  it { is_expected.to accept_argument(:addon_clause).of_type('Int') }
end
