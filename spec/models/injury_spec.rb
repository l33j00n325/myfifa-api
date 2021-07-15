# frozen_string_literal: true

# == Schema Information
#
# Table name: injuries
#
#  id          :bigint           not null, primary key
#  description :string
#  ended_on    :date
#  started_on  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#
# Indexes
#
#  index_injuries_on_player_id  (player_id)
#

require 'rails_helper'

describe Injury, type: :model do
  let(:injury) { create :injury }

  it 'has a valid factory' do
    expect(create(:injury)).to be_valid
  end

  it 'requires a description' do
    expect(build(:injury, description: nil)).not_to be_valid
  end

  it 'has an end date after start date' do
    injury = build :injury,
                   started_on: Faker::Date.forward(days: 1),
                   ended_on: Faker::Date.backward(days: 1)
    expect(injury).not_to be_valid
  end

  it 'is rejected for already injured Players' do
    expect(build(:injury, player: injury.player)).not_to be_valid
  end

  it 'occurs on the Team current date' do
    expect(injury.started_on).to be == injury.team.currently_on
  end

  it 'sets ended on timestamp to Team current date when recovered' do
    injury.team.increment_date(2.days)
    injury.update(recovered: true)
    expect(injury.ended_on).to be == injury.team.currently_on
  end

  it 'changes Player status to injured when injured' do
    expect(injury.player.injured?).to be true
  end

  it 'changes Player status when no longer injured' do
    player = injury.player
    player.injuries.last.update(recovered: true)
    expect(player.active?).to be true
  end
end
