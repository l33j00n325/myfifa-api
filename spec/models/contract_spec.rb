# frozen_string_literal: true

# == Schema Information
#
# Table name: contracts
#
#  id                :bigint           not null, primary key
#  bonus_req         :integer
#  bonus_req_type    :string
#  conclusion        :string
#  ended_on          :date
#  performance_bonus :integer
#  release_clause    :integer
#  signed_on         :date
#  signing_bonus     :integer
#  started_on        :date
#  wage              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  player_id         :bigint
#
# Indexes
#
#  index_contracts_on_player_id  (player_id)
#

require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:contract) { FactoryBot.create(:contract) }
  let(:perf_bonus) { Faker::Number.between(from: 10_000, to: 1_000_000) }
  let(:bonus_req) { Faker::Number.between(from: 1, to: 25) }
  let(:bonus_req_type) { Contract::BONUS_REQUIREMENT_TYPES.sample }

  it "has a valid factory" do
    expect(contract).to be_valid
  end

  it 'requires an effective date' do
    expect(FactoryBot.build(:contract, started_on: nil)).to_not be_valid
  end

  it 'requires an end date' do
    expect(FactoryBot.build(:contract, ended_on: nil)).to_not be_valid
  end

  it 'requires a wage' do
    expect(FactoryBot.build(:contract, wage: nil)).to_not be_valid
  end

  it 'has a valid bonus requirement type if present' do
    expect(FactoryBot.build(:contract, bonus_req: bonus_req, performance_bonus: perf_bonus, bonus_req_type: Faker::Lorem.word)).to_not be_valid
  end

  it 'rejects ended_on if num_seasons is provided' do
    player = FactoryBot.create(:player)
    contract = FactoryBot.build(:contract, player: player, ended_on: 365.days.from_now, num_seasons: 2)
    expect(contract.ended_on).to_not be == 365.days.from_now
  end

  it 'sets ended_on automatically if num_seasons is set' do
    player = FactoryBot.create(:player)
    contract = FactoryBot.build(:contract, player: player, num_seasons: 3)
    expect(contract.ended_on).to be == player.team.started_on + 3.years
  end

  it 'sets ended_on correctly if started during 2nd half of season and num_seasons is set' do
    player = FactoryBot.create(:player)
    contract = FactoryBot.build(:contract, player: player, started_on: player.team.started_on + 7.months, num_seasons: 3)
    expect(contract.ended_on).to be == player.team.started_on + 4.years
  end

  it 'sets ended_on to end of season if started during 2nd half of season with no years and num_seasons is set to 0' do
    player = FactoryBot.create(:player)
    contract = FactoryBot.build(:contract, player: player, started_on: player.team.started_on + 7.months, num_seasons: 0)
    expect(contract.ended_on).to be == player.team.started_on + 1.years
  end

  it 'sets Player as Pending if started_on > current date' do
    future_date = Faker::Date.between from: 1.days.from_now,
                                      to: 365.days.from_now
    contract = FactoryBot.create :contract, started_on: future_date
    expect(contract.player.status).to be == 'Pending'
  end

  it 'sets Pending Player as Active once current date reaches effective date' do
    future_date = Faker::Date.between from: 1.days.from_now,
                                      to: 365.days.from_now
    contract = FactoryBot.create :contract, started_on: future_date
    contract.player.team.update(currently_on: future_date)
    expect(contract.player.reload.active?).to be == true
  end

  it 'sets new Player as Active if effective date < current date' do
    player = FactoryBot.create :player, contracts_count: 0
    FactoryBot.create :contract, player: player
    expect(player.active?).to be true
  end

  it 'sets Active Player as Inactive once contract expires' do
    player = FactoryBot.create :player
    player.last_contract.update(ended_on: 1.day.from_now)
    player.team.increment_date(1.week)
    player.reload
    expect(player.active?).to be_falsey
    expect(player.last_contract.conclusion).to be == 'Expired'
  end

  it 'provides all three fields for a performance bonus' do
    expect(FactoryBot.build(:contract, performance_bonus: perf_bonus)).to_not be_valid
    expect(FactoryBot.build(:contract, bonus_req: bonus_req)).to_not be_valid
    expect(FactoryBot.build(:contract, bonus_req_type: bonus_req_type)).to_not be_valid
    expect(FactoryBot.build(:contract, performance_bonus: perf_bonus, bonus_req: bonus_req)).to_not be_valid
    expect(FactoryBot.build(:contract, performance_bonus: perf_bonus, bonus_req_type: bonus_req_type)).to_not be_valid
    expect(FactoryBot.build(:contract, bonus_req: bonus_req, bonus_req_type: bonus_req_type)).to_not be_valid
    expect(FactoryBot.create(:contract, bonus_req: bonus_req, performance_bonus: perf_bonus, bonus_req_type: bonus_req_type)).to be_valid
  end

  it 'ends tracking of any injuries upon expiration' do
    @player = FactoryBot.create(:player)
    FactoryBot.create :contract,
                      player: @player,
                      started_on: @player.currently_on,
                      ended_on: @player.currently_on + 1.week
    FactoryBot.create :injury, player: @player
    @player.team.increment_date 1.week
    @player.reload
    expect(@player.injured?).to be false
    expect(@player.injuries.last.ended_on).to be == @player.currently_on
  end

  it 'ends contract immediately when terminated' do
    team = contract.team
    contract.update(ended_on: team.currently_on + 2.year)
    contract.terminate!
    expect(contract.active?).to be_falsey
    expect(contract.conclusion).to be == 'Released'
  end

  it 'end contract at the end of the season when retired' do
    team = contract.team
    contract.update(ended_on: team.currently_on + 2.year)
    contract.retire!
    expect(contract.ended_on).to be == team.end_of_season + 1.day
    expect(contract.conclusion).to be == 'Retired'
  end

  it 'terminates the previous contract' do
    contract.team.increment_date(1.month)
    player = contract.player

    new_contract = player.contracts.create(
      FactoryBot.attributes_for :contract, started_on: player.currently_on
    )

    expect(player.reload.active?).to be_truthy
    expect(contract.reload.ended_on).to be == contract.currently_on
    expect(contract.reload.conclusion).to be == 'Renewed'
  end
end
