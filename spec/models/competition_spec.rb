# frozen_string_literal: true

# == Schema Information
#
# Table name: competitions
#
#  id         :bigint           not null, primary key
#  champion   :string
#  name       :string
#  season     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_competitions_on_season   (season)
#  index_competitions_on_team_id  (team_id)
#

require 'rails_helper'

describe Competition, type: :model do
  let(:competition) { create(:competition) }

  it 'has a valid factory' do
    expect(competition).to be_valid
  end

  it 'requires a season' do
    expect(build(:competition, season: nil)).not_to be_valid
  end

  it 'requires a name' do
    expect(build(:competition, name: nil)).not_to be_valid
  end

  it 'rejects invalid preset formats' do
    expect(build(:competition, preset_format: 'Wrong')).not_to be_valid
  end

  it 'requires a num_team if League' do
    expect(build(:league, num_teams: nil)).not_to be_valid
  end

  it 'rejects invalid Knockout settings' do
    expect(build(:cup, num_teams: 14)).not_to be_valid
  end

  %i[
    num_teams
    num_teams_per_group
    num_advances_from_group
  ].each do |preset_attr|
    it "requires #{preset_attr} if invalid Group + Knockout" do
      expect(build(:tournament, preset_attr => nil)).not_to be_valid
    end
  end

  [
    [{ num_teams: 32, num_teams_per_group: 4, num_advances_from_group: 2 }, true],
    [{ num_teams: 8,  num_teams_per_group: 4, num_advances_from_group: 2 }, true],
    [{ num_teams: 24, num_teams_per_group: 3, num_advances_from_group: 2 }, true],
    [{ num_teams: 32, num_teams_per_group: 6, num_advances_from_group: 2 }, false],
    [{ num_teams: 30, num_teams_per_group: 6, num_advances_from_group: 2 }, false]
  ].each do |preset, expect_valid|
    if expect_valid
      it "accepts Group+Knockout setting (#{preset}) as valid" do
        expect(build(:tournament, preset)).to be_valid
      end
    else
      it "rejects Groups+Knockout setting (#{preset}) as invalid" do
        expect(build(:tournament, preset)).not_to be_valid
      end
    end
  end

  describe 'if League' do
    let(:num_teams) { Faker::Number.between(from: 2, to: 30).to_i }
    let(:league) { create :league, num_teams: num_teams }

    it 'creates 1 stage' do
      expect(league.stages.count).to be == 1
    end

    it 'creates table rows for number of teams' do
      expect(league.stages.first.table_rows.size).to be == num_teams
    end
  end

  describe 'if Cup' do
    let(:num_rounds) { Faker::Number.between(from: 1, to: 6).to_i }
    let(:num_teams) { 2**num_rounds }
    let(:cup) { create :cup, num_teams: num_teams }

    it 'creates log(2) Knockout stages' do
      expect(cup.stages.size).to be == num_rounds
    end

    it 'creates a cascading number of fixtures for each Knockout stage' do
      cup.stages.includes(:fixtures).each_with_index do |round, i|
        num_round_teams = num_teams / 2**i
        expect(round.fixtures.size).to be == num_round_teams / 2
      end
    end
  end

  [
    { num_teams: 32, num_teams_per_group: 4, num_advances_from_group: 2 },
    { num_teams: 8, num_teams_per_group: 4, num_advances_from_group: 2 },
    { num_teams: 24, num_teams_per_group: 3, num_advances_from_group: 2 },
  ].each do |preset|
    describe "if Group+Knockout with preset (#{preset})" do
      let(:tournament) { create :tournament, preset }

      num_groups = preset[:num_teams] / preset[:num_teams_per_group]
      num_rounds = Math.log(num_groups * preset[:num_advances_from_group], 2).to_i

      it "creates #{num_groups} groups" do
        expect(tournament.stages.where(table: true).size).to be == num_groups
      end

      it "creates groups of size #{preset[:num_teams_per_group]}" do
        tournament.stages.includes(:table_rows).where(table: true).each do |group|
          expect(group.table_rows.size).to be == preset[:num_teams_per_group]
        end
      end

      it "creates #{num_rounds} knockout rounds" do
        expect(tournament.stages.where(table: false).size).to be == num_rounds
      end

      it 'creates a cascading number of fixtures for each Knockout stage' do
        tournament
          .stages
          .includes(:fixtures)
          .where(table: false)
          .each_with_index do |round, i|
            num_round_teams = num_groups * preset[:num_advances_from_group] / 2**i
            expect(round.fixtures.size).to be == num_round_teams / 2
          end
      end
    end
  end
end
