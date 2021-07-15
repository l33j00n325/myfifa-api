# frozen_string_literal: true

# == Schema Information
#
# Table name: squad_players
#
#  id         :bigint           not null, primary key
#  pos        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :bigint
#  squad_id   :bigint
#
# Indexes
#
#  index_squad_players_on_player_id  (player_id)
#  index_squad_players_on_squad_id   (squad_id)
#

require 'rails_helper'

describe SquadPlayer, type: :model do
  let(:squad_player) { create(:squad_player) }

  it 'has a valid factory' do
    expect(squad_player).to be_valid
  end

  it 'requires a position' do
    expect(build(:squad_player, pos: nil)).not_to be_valid
  end

  it 'requires a player' do
    expect(build(:squad_player, player_id: nil)).not_to be_valid
  end

  it 'requires a squad' do
    expect(build(:squad_player, squad_id: nil)).not_to be_valid
  end

  it 'requires a player and squad of the same team' do
    squad_player = build :squad_player,
                         player: create(:player),
                         squad: create(:squad)
    expect(squad_player).not_to be_valid
  end
end
