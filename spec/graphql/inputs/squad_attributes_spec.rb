# frozen_string_literal: true

require 'rails_helper'

describe Types::Inputs::SquadAttributes do
  subject(:squad_attributes) { described_class }

  it { is_expected.to accept_argument(:name).of_type('String!') }

  it do
    expect(squad_attributes).to(
      accept_argument(:squad_players_attributes)
        .of_type('[SquadPlayerAttributes!]!')
    )
  end
end
