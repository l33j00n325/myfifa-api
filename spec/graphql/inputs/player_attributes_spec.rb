# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::PlayerAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:name).of_type('String') }
  it { is_expected.to accept_argument(:nationality).of_type('String') }
  it { is_expected.to accept_argument(:pos).of_type('String') }
  it { is_expected.to accept_argument(:sec_pos).of_type('[String!]') }
  it { is_expected.to accept_argument(:ovr).of_type('Int') }
  it { is_expected.to accept_argument(:value).of_type('Int') }
  it { is_expected.to accept_argument(:youth).of_type('Boolean') }
  it { is_expected.to accept_argument(:kit_no).of_type('Int') }

  it { is_expected.to accept_argument(:age).of_type('Int') }

  it { is_expected.to accept_argument(:contracts_Attributes).of_type('[ContractAttributes!]') }
end
