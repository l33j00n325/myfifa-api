# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::TableRowAttributes do
  subject { described_class }

  it { is_expected.to accept_argument(:name).of_type('String') }
  it { is_expected.to accept_argument(:wins).of_type('Int') }
  it { is_expected.to accept_argument(:draws).of_type('Int') }
  it { is_expected.to accept_argument(:losses).of_type('Int') }
  it { is_expected.to accept_argument(:goals_for).of_type('Int') }
  it { is_expected.to accept_argument(:goals_against).of_type('Int') }
end
