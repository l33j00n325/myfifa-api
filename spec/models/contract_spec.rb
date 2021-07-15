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

describe Contract, type: :model do
  let(:player) { create :player }
  let(:contract) { create :contract }
  let(:perf_bonus) { Faker::Number.between from: 10_000, to: 1_000_000 }
  let(:bonus_req) { Faker::Number.between from: 1, to: 25 }
  let(:bonus_req_type) { Contract::BONUS_REQUIREMENT_TYPES.sample }

  it 'has a valid factory' do
    expect(contract).to be_valid
  end

  it 'requires an effective date' do
    expect(build(:contract, started_on: nil)).not_to be_valid
  end

  it 'requires an end date' do
    expect(build(:contract, ended_on: nil)).not_to be_valid
  end

  it 'requires a wage' do
    expect(build(:contract, wage: nil)).not_to be_valid
  end

  it 'rejects performance bonus if no bonus req or bonus req type' do
    expect(build(:contract, performance_bonus: perf_bonus)).not_to be_valid
  end

  it 'rejects bonus req if no performance bonus or bonus req type' do
    expect(build(:contract, bonus_req: bonus_req)).not_to be_valid
  end

  it 'rejects bonus req type if no performance bonus or bonus req' do
    expect(build(:contract, bonus_req_type: bonus_req_type)).not_to be_valid
  end

  it 'rejects performance bonus and bonus req if no bonus req type' do
    contract = build :contract,
                     performance_bonus: perf_bonus,
                     bonus_req: bonus_req
    expect(contract).not_to be_valid
  end

  it 'rejects performance bonus and bonus req type if no bonus req' do
    contract = build :contract,
                     performance_bonus: perf_bonus,
                     bonus_req_type: bonus_req_type
    expect(contract).not_to be_valid
  end

  it 'rejects bonus req and bonus req type if no performance bonus' do
    contract = build :contract,
                     bonus_req: bonus_req,
                     bonus_req_type: bonus_req_type
    expect(contract).not_to be_valid
  end

  it 'accepts performance bonus, bonus req and bonus req type' do
    contract = create :contract,
                      bonus_req: bonus_req,
                      bonus_req_type: bonus_req_type,
                      performance_bonus: perf_bonus
    expect(contract).to be_valid
  end

  it 'rejects ended_on if num_seasons is provided' do
    contract = build :contract,
                     player: player,
                     ended_on: 365.days.from_now,
                     num_seasons: 2
    expect(contract.ended_on).not_to be == 365.days.from_now
  end

  it 'sets ended_on automatically if num_seasons is set' do
    contract = build :contract, player: player, num_seasons: 3
    expect(contract.ended_on).to be == player.team.started_on + 3.years
  end

  it 'sets ended_on correctly if started during 2nd half of season and num_seasons is set' do
    contract = build :contract,
                     player: player,
                     started_on: player.team.started_on + 7.months,
                     num_seasons: 3
    expect(contract.ended_on).to be == player.team.started_on + 4.years
  end

  it 'sets ended_on to end of season ' \
     'if started during 2nd half of season with no years and num_seasons is set to 0' do
    contract = build :contract,
                     player: player,
                     started_on: player.team.started_on + 7.months,
                     num_seasons: 0
    expect(contract.ended_on).to be == player.team.started_on + 1.year
  end

  it 'sets Player as Pending if started_on > current date' do
    future_date = Faker::Date.between from: 1.day.from_now,
                                      to: 365.days.from_now
    contract = create :contract, started_on: future_date
    expect(contract.player.status).to be == 'Pending'
  end

  it 'sets Pending Player as Active once current date reaches effective date' do
    future_date = Faker::Date.between from: 1.day.from_now,
                                      to: 365.days.from_now
    contract = create :contract,
                      started_on: future_date,
                      ended_on: future_date + 1.year
    contract.player.team.update(currently_on: future_date)
    expect(contract.player.reload.active?).to be == true
  end

  it 'sets new Player as Active if effective date < current date' do
    player = create :player, contracts_count: 0
    create :contract, player: player
    expect(player.active?).to be true
  end

  describe 'once expired' do
    before do
      player.last_contract.update(ended_on: 1.day.from_now)
      player.team.increment_date(1.week)
      player.reload
    end

    it 'sets Player status as Inactive' do
      expect(player).not_to be_active
    end

    it "sets conclusion as 'Expired'" do
      expect(player.last_contract.conclusion).to be == 'Expired'
    end
  end

  describe 'when expired for Injured Player' do
    before do
      create :contract,
             player: player,
             started_on: player.currently_on,
             ended_on: player.currently_on + 1.week
      create :injury, player: player
      player.team.increment_date 1.week
      player.reload
    end

    it 'stops regarding Player as injured' do
      expect(player).not_to be_injured
    end

    it 'stops tracking injury' do
      expect(player.last_injury.ended_on).to be == player.currently_on
    end
  end

  describe 'when terminated' do
    let(:contract) do
      create :contract, player: player, ended_on: player.team.currently_on + 2.years
    end

    before do
      contract.terminate!
    end

    it 'immediately expires' do
      expect(contract).not_to be_active
    end

    it "sets conclusion as 'Released'" do
      expect(contract.conclusion).to be == 'Released'
    end
  end

  describe 'when retired' do
    let(:contract) do
      create :contract, player: player, ended_on: player.team.currently_on + 2.years
    end

    before do
      contract.retire!
    end

    it 'sets expirate date to end of the season' do
      expect(contract.ended_on).to be == player.team.end_of_season + 1.day
    end

    it "sets conclusion as 'Retired'" do
      expect(contract.conclusion).to be == 'Retired'
    end
  end

  describe 'when renewing an existing contract' do
    before do
      contract.team.increment_date(1.month)
      player = contract.player
      create :contract, player: player, started_on: player.currently_on
    end

    it 'keeps the player as Active' do
      expect(player.reload).to be_active
    end

    it 'terminates the previous contract' do
      expect(contract.reload.ended_on).to be == contract.currently_on
    end

    it "sets previous conclusion as 'Renewed'" do
      expect(contract.reload.conclusion).to be == 'Renewed'
    end
  end
end
