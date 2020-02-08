# frozen_string_literal: true

# == Schema Information
#
# Table name: squads
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_squads_on_team_id  (team_id)
#

require 'rails_helper'

RSpec.describe Squad, type: :model do
  let(:squad) { FactoryBot.create(:squad) }

  it "has a valid factory" do
    expect(squad).to be_valid
  end

  it 'requires 11 positions' do
    [
      Faker::Number.between(from: 0, to: 10),
      Faker::Number.between(from: 12, to: 20)
    ].each do |i|
      squad = FactoryBot.build :squad, players_count: i
      expect(squad).to_not be_valid
    end
  end

  it 'cannot have duplicate positions' do
    squad = FactoryBot.build :squad, players_count: 10
    taken_positions = squad.squad_players.map(&:pos)
    squad.squad_players << FactoryBot.build(:squad_player, pos: taken_positions[0])
    expect(squad).to_not be_valid
  end

  it 'cannot have duplicate player ids' do
    squad = FactoryBot.build :squad, players_count: 10
    taken_player_ids = squad.squad_players.map(&:player_id)
    squad.squad_players << FactoryBot.build(:squad_player, player_id: taken_player_ids[0])
    expect(squad).to_not be_valid
  end

  describe 'when Match lineup is stored' do
    let(:match) { FactoryBot.create :match, team: squad.team }

    before do
      11.times do |i|
        player = FactoryBot.create :player, team: match.team
        FactoryBot.create :cap, match: match, player: player, start: 0, pos: Cap::POSITIONS[i]
      end
    end

    it 'removes previous SquadPlayers' do
      old_record = squad.squad_players.first
      squad.store_lineup(match)
      expect { old_record.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'creates SquadPlayers matching Caps' do
      squad.store_lineup(match)
      expect(squad.squad_players.pluck(:player_id)).to be == match.caps.pluck(:player_id)
      expect(squad.squad_players.pluck(:pos)).to be == match.caps.pluck(:pos)
    end
  end
end
