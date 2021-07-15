# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::CompetitionAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:season).of_type('Int') }
  it { is_expected.to accept_argument(:name).of_type('String') }
  it { is_expected.to accept_argument(:champion).of_type('String') }

  it { is_expected.to accept_argument(:preset_format).of_type('String') }
  it { is_expected.to accept_argument(:num_teams).of_type('Int') }
  it { is_expected.to accept_argument(:num_teams_per_group).of_type('Int') }
  it { is_expected.to accept_argument(:num_advances_from_group).of_type('Int') }
end
