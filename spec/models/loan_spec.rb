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

RSpec.describe Loan, type: :model do
  let(:player) { FactoryBot.create(:player)}

  it "has a valid factory" do
    expect(FactoryBot.create(:loan)).to be_valid
  end

  it 'requires an origin' do
    expect(FactoryBot.build(:loan, origin: nil)).to_not be_valid
  end

  it 'requires a destination' do
    expect(
      FactoryBot.build(:loan, destination: nil)).to_not be_valid
  end

  it 'only accepts a valid wage percentage' do
    expect(FactoryBot.build(:loan, wage_percentage: nil)).to be_valid
    expect(FactoryBot.build(:loan, wage_percentage: -1)).to_not be_valid
    expect(FactoryBot.build(:loan, wage_percentage: 101)).to_not be_valid
  end

  it 'has an end date after start date' do
    expect(
      FactoryBot.build :loan,
                       started_on: Faker::Date.forward(days: 1),
                       ended_on: Faker::Date.backward(days: 1)
    ).to_not be_valid
  end

  it 'sets signed date to the Team current date' do
    loan = FactoryBot.create(:loan)
    expect(loan.signed_on).to be == loan.team.currently_on
  end

  it 'sets end date to the Team current date' do
    loan = FactoryBot.create :loan
    loan.team.increment_date 2.days
    loan.update returned: true
    expect(loan.ended_on).to be == loan.team.currently_on
  end

  it 'changes status to loaned when loaned out' do
    FactoryBot.create :loan,
                      player: player,
                      started_on: player.currently_on,
                      origin: player.team.title
    expect(player.loaned?).to be true
  end

  it 'does not change status to loaned when loaned in' do
    FactoryBot.create :loan,
                      player: player,
                      started_on: player.currently_on,
                      destination: player.team.title
    expect(player.loaned?).to_not be true
  end

  it 'changes status when loaned Player returns to team' do
    FactoryBot.create :loan,
                      player: player,
                      origin: player.team.title
    player.loans.last.update returned: true
    expect(player.active?).to be true
  end

  it 'ends the current contract if loaned ends and player leaves' do
    player = FactoryBot.create :player
    loan = FactoryBot.create :loan,
                             player: player,
                             origin: Faker::Team.name,
                             destination: player.team.title
    player.team.increment_date 1.year
    loan.update returned: true

    expect(player.status).to be_nil
    expect(player.contracts.last.ended_on).to be == player.currently_on
  end

  it 'ends tracking of any injuries upon creation' do
    FactoryBot.create :injury, player: player
    FactoryBot.create :loan,
                      player: player,
                      origin: player.team.title,
                      started_on: player.currently_on
    expect(player.injured?).to be false
    expect(player.injuries.last.ended_on).to be == player.currently_on
  end
end
