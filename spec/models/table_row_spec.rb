# frozen_string_literal: true

# == Schema Information
#
# Table name: table_rows
#
#  id            :bigint           not null, primary key
#  draws         :integer          default(0)
#  goals_against :integer          default(0)
#  goals_for     :integer          default(0)
#  losses        :integer          default(0)
#  name          :string
#  wins          :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stage_id      :bigint
#
# Indexes
#
#  index_table_rows_on_stage_id  (stage_id)
#

require 'rails_helper'

describe TableRow, type: :model do
  let(:row) { create(:table_row) }

  it 'has a valid factory' do
    expect(row).to be_valid
  end

  it 'requires wins' do
    expect(build(:table_row, wins: nil)).not_to be_valid
  end

  it 'requires draws' do
    expect(build(:table_row, draws: nil)).not_to be_valid
  end

  it 'requires losses' do
    expect(build(:table_row, losses: nil)).not_to be_valid
  end

  it 'requires goals_for' do
    expect(build(:table_row, goals_for: nil)).not_to be_valid
  end

  it 'requires goals_against' do
    expect(build(:table_row, goals_against: nil)).not_to be_valid
  end

  it 'requires name when updating' do
    row.name = nil
    expect(row).not_to be_valid
  end

  it 'correctly calculates goal_difference' do
    gf = Faker::Number.between(from: 0, to: 100).to_i
    ga = Faker::Number.between(from: 0, to: 100).to_i
    row.goals_for = gf
    row.goals_against = ga
    expect(row.goal_difference == gf - ga).to be true
  end

  it 'correctly calculates points' do
    wins = Faker::Number.number(digits: 2).to_i
    draws = Faker::Number.number(digits: 2).to_i
    row.wins = wins
    row.draws = draws
    expect(row.points == 3 * wins + draws).to be true
  end
end
