# frozen_string_literal: true

# == Schema Information
#
# Table name: loans
#
#  id              :bigint           not null, primary key
#  destination     :string
#  ended_on        :date
#  origin          :string
#  signed_on       :date
#  started_on      :date
#  wage_percentage :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  player_id       :bigint
#
# Indexes
#
#  index_loans_on_player_id  (player_id)
#

require 'rails_helper'

describe Loan, type: :model do
  let(:player) { create(:player) }

  it 'has a valid factory' do
    expect(create(:loan)).to be_valid
  end

  it 'requires an origin' do
    expect(build(:loan, origin: nil)).not_to be_valid
  end

  it 'requires a destination' do
    expect(build(:loan, destination: nil)).not_to be_valid
  end

  it 'only accepts a wage percentage' do
    expect(build(:loan, wage_percentage: nil)).to be_valid
  end

  it 'has an end date after start date' do
    loan = build :loan,
                 started_on: Faker::Date.forward(days: 1),
                 ended_on: Faker::Date.backward(days: 1)
    expect(loan).not_to be_valid
  end

  it 'sets signed date to the Team current date' do
    loan = create(:loan)
    expect(loan.signed_on).to be == loan.team.currently_on
  end

  it 'sets end date to the Team current date' do
    loan = create :loan
    loan.team.increment_date 2.days
    loan.update returned: true
    expect(loan.ended_on).to be == loan.team.currently_on
  end

  it 'changes status to loaned when loaned out' do
    create :loan,
           player: player,
           started_on: player.currently_on,
           origin: player.team.name
    expect(player.loaned?).to be true
  end

  it 'does not change status to loaned when loaned in' do
    create :loan,
           player: player,
           started_on: player.currently_on,
           destination: player.team.name
    expect(player.loaned?).not_to be true
  end

  it 'changes status when loaned Player returns to team' do
    create :loan,
           player: player,
           origin: player.team.name
    player.loans.last.update returned: true
    expect(player.active?).to be true
  end

  describe 'if ended and player leaves' do
    let(:loan) do
      create :loan, player: player, origin: Faker::Team.name, destination: player.team.name
    end

    before do
      player.team.increment_date 1.year
      loan.update returned: true
    end

    it 'sets Player status as Inactive' do
      expect(player.status).to be_nil
    end

    it 'deactivates the Player contract' do
      expect(player.last_contract.ended_on).to be == player.currently_on
    end
  end

  describe 'when created for Injured Player' do
    before do
      create :injury, player: player
      create :loan,
             player: player,
             origin: player.team.name,
             started_on: player.currently_on
    end

    it 'stops regarding Player as injured' do
      expect(player).not_to be_injured
    end

    it 'stops tracking injury' do
      expect(player.last_injury.ended_on).to be == player.currently_on
    end
  end
end
