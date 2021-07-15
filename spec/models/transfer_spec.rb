# frozen_string_literal: true

# == Schema Information
#
# Table name: transfers
#
#  id            :bigint           not null, primary key
#  addon_clause  :integer
#  destination   :string
#  fee           :integer
#  moved_on      :date
#  origin        :string
#  signed_on     :date
#  traded_player :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  player_id     :bigint
#
# Indexes
#
#  index_transfers_on_player_id  (player_id)
#

require 'rails_helper'

describe Transfer, type: :model do
  let(:player) { create :player }

  it 'has a valid factory' do
    expect(create(:transfer)).to be_valid
  end

  it 'requires an origin' do
    expect(build(:transfer, origin: nil)).not_to be_valid
  end

  it 'requires a destination' do
    expect(build(:transfer, destination: nil)).not_to be_valid
  end

  it 'has a valid add-on clause if any' do
    expect(build(:transfer, addon_clause: -1)).not_to be_valid
  end

  it 'is signed on the team current date' do
    transfer = create :transfer
    expect(transfer.signed_on).to be == transfer.team.currently_on
  end

  describe 'if immediate' do
    before do
      create :transfer,
             player: player,
             origin: player.team.name,
             moved_on: player.currently_on
    end

    it 'clears Player status' do
      expect(player.status).to be_nil
    end

    it 'ends the current contract' do
      expect(player.last_contract.ended_on).to be == player.currently_on
    end

    it "concludes the current contract as 'Transferred'" do
      expect(player.last_contract.conclusion).to be == 'Transferred'
    end
  end

  describe 'in future' do
    before do
      create :transfer,
             player: player,
             origin: player.team.name,
             moved_on: player.currently_on + 1.week
    end

    it 'does not immediately clear Player status' do
      expect(player.status).not_to be_nil
    end
  end

  describe 'in future once current date == effective date' do
    before do
      create :transfer,
             player: player,
             origin: player.team.name,
             moved_on: player.currently_on + 1.week
      player.team.increment_date 1.week
    end

    it 'clears Player status' do
      expect(player.reload.status).to be_nil
    end

    it 'ends the current contract' do
      expect(player.last_contract.ended_on).to be == player.currently_on
    end

    it "concludes the current contract as 'Transferred'" do
      expect(player.last_contract.conclusion).to be == 'Transferred'
    end
  end
end
