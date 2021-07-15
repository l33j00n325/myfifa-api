# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id          :bigint           not null, primary key
#  away        :string
#  away_score  :integer          default(0)
#  competition :string
#  extra_time  :boolean          default(FALSE), not null
#  friendly    :boolean          default(FALSE), not null
#  home        :string
#  home_score  :integer          default(0)
#  played_on   :date
#  season      :integer
#  stage       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#

require 'rails_helper'

describe Match, type: :model do
  let(:team) { create :team }
  let(:match) { create :match, team: team }

  it 'has a valid factory' do
    expect(match).to be_valid
  end

  it 'requires a home team' do
    expect(build(:match, home: nil)).not_to be_valid
  end

  it 'requires an away team' do
    expect(build(:match, away: nil)).not_to be_valid
  end

  it 'requires a competition' do
    expect(build(:match, competition: nil)).not_to be_valid
  end

  it 'does not require a competition if friendly' do
    expect(build(:match, competition: nil, friendly: true)).to be_valid
  end

  it 'cannot have duplicate home and away teams' do
    team_name = Faker::Team.name
    expect(build(:match, home: team_name, away: team_name)).not_to be_valid
  end

  it 'detects when user team is not playing' do
    expect(build(:match).team_played?).to be false
  end

  it 'detects when user team is playing home' do
    match = build :match, team: team, home: team.name
    expect(match.team_played?).to be true
  end

  it 'automatically sets the season based on Team start' do
    match = create :match,
                   team: team,
                   played_on: team.currently_on + 1.year
    expect(match.season).to be == 1
  end

  it 'detects when user team is playing away' do
    match = build :match, team: team, away: team.name
    expect(match.team_played?).to be true
  end

  it 'starts off 0 - 0' do
    expect(match.score).to be == '0 - 0'
  end

  it 'cannot have two Performance records for the same player' do
    player = create :player, team: team
    create :cap, match: match, player: player
    expect(build(:cap, match: match, player: player)).not_to be_valid
  end

  it 'sets Match times to 120 minutes if extra time' do
    player = create :player, team: team
    cap = create :cap, match: match, player: player
    match.update(extra_time: true)
    expect(cap.reload.stop).to be == 120
  end

  it 'sets Match times to 90 minutes if not extra time' do
    match = create :match, extra_time: true
    player = create :player, team: match.team
    cap = create :cap, match: match, player: player
    match.update(extra_time: false)
    expect(cap.reload.stop).to be == 90
  end

  %i[home away].each do |side|
    opposite_side = side == :home ? :away : :home

    describe "when Team is #{side}" do
      it 'detects team win' do
        match = create :match,
                       team: team,
                       side => team.name,
                       "#{side}_score" => 1,
                       "#{opposite_side}_score" => 0
        expect(match.team_result).to be == 'win'
      end

      it 'detects team draw' do
        match = create :match,
                       team: team,
                       side => team.name,
                       "#{side}_score" => 1,
                       "#{opposite_side}_score" => 1
        expect(match.team_result).to be == 'draw'
      end

      it 'detects team loss' do
        match = create :match,
                       team: team,
                       side => team.name,
                       "#{side}_score" => 0,
                       "#{opposite_side}_score" => 1
        expect(match.team_result).to be == 'loss'
      end
    end
  end

  it 'does not move current date forward if date is behind current date' do
    match.update(played_on: match.currently_on - 1.day)
    expect(match.team.reload.currently_on).not_to be == match.played_on
  end

  it 'moves current date forward if date is ahead of current date' do
    match.update(played_on: match.currently_on + 1.day)
    expect(match.team.reload.currently_on).to be == match.played_on
  end

  describe 'when Squad is applied' do
    let(:squad) { create :squad, team: match.team }

    it 'removes previous Caps' do
      player = create :player, team: match.team
      cap = create :cap, match: match, player: player
      match.apply(squad)
      expect { cap.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "creates Caps matching SquadPlayers' player ids" do
      match.apply(squad)
      expect(match.caps.pluck(:player_id)).to be == squad.squad_players.pluck(:player_id)
    end

    it "creates Caps matching SquadPlayers' positions" do
      match.apply(squad)
      expect(match.caps.pluck(:pos)).to be == squad.squad_players.pluck(:pos)
    end
  end
end
