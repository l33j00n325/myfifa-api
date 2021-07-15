# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::StageAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:name).of_type('String') }
  it { is_expected.to accept_argument(:num_teams).of_type('Int') }
  it { is_expected.to accept_argument(:num_fixtures).of_type('Int') }
  it { is_expected.to accept_argument(:table).of_type('Boolean') }
end
