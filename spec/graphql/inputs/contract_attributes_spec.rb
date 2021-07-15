# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::ContractAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:wage).of_type('Int!') }
  it { is_expected.to accept_argument(:signing_bonus).of_type('Int') }
  it { is_expected.to accept_argument(:release_clause).of_type('Int') }
  it { is_expected.to accept_argument(:performance_bonus).of_type('Int') }
  it { is_expected.to accept_argument(:bonus_req).of_type('Int') }
  it { is_expected.to accept_argument(:bonus_req_type).of_type('String') }
  it { is_expected.to accept_argument(:ended_on).of_type('ISO8601Date!') }
  it { is_expected.to accept_argument(:started_on).of_type('ISO8601Date!') }

  it { is_expected.to accept_argument(:num_seasons).of_type('Int') }
end
