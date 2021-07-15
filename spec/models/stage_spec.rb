# frozen_string_literal: true

# == Schema Information
#
# Table name: stages
#
#  id             :bigint           not null, primary key
#  name           :string
#  num_fixtures   :integer
#  num_teams      :integer
#  table          :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :bigint
#
# Indexes
#
#  index_stages_on_competition_id  (competition_id)
#

require 'rails_helper'

describe Stage, type: :model do
  let(:stage) { create :stage }

  it 'has a valid factory' do
    expect(stage).to be_valid
  end

  it 'requires a num_team' do
    expect(build(:stage, num_teams: nil)).not_to be_valid
  end

  it 'requires a num_fixtures' do
    expect(build(:stage, num_fixtures: nil)).not_to be_valid
  end

  it 'sets default name to Quarter-Finals if 8 teams' do
    expect(build(:stage, num_teams: 8).name).to be == 'Quarter-Finals'
  end

  it 'sets default name to Semi-Finals if 4 teams' do
    expect(build(:stage, num_teams: 4).name).to be == 'Semi-Finals'
  end

  it 'sets default name to Final to 2 teams' do
    expect(build(:stage, num_teams: 2).name).to be == 'Final'
  end

  it 'sets default name depending on number of teams' do
    num_teams = Faker::Number.between(from: 9, to: 20)
    expect(build(:stage, num_teams: num_teams).name).to be == "Round of #{num_teams}"
  end

  describe 'if table' do
    let(:stage) { create :stage, table: true }

    it 'creates table rows' do
      expect(stage.table_rows.size).to be == stage.num_teams
    end

    it 'does not create fixtures' do
      expect(stage.fixtures.size).to be == 0
    end
  end

  describe 'if round' do
    it 'does not create table rows' do
      expect(stage.table_rows.size).to be == 0
    end

    it 'creates fixtures' do
      expect(stage.fixtures.size).to be == stage.num_fixtures
    end
  end
end
