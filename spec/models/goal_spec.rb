# frozen_string_literal: true

# == Schema Information
#
# Table name: goals
#
#  id          :bigint           not null, primary key
#  assisted_by :string
#  home        :boolean          default(FALSE), not null
#  minute      :integer
#  own_goal    :boolean          default(FALSE), not null
#  penalty     :boolean          default(FALSE), not null
#  player_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  assist_id   :bigint
#  match_id    :bigint
#  player_id   :bigint
#
# Indexes
#
#  index_goals_on_assist_id  (assist_id)
#  index_goals_on_match_id   (match_id)
#  index_goals_on_player_id  (player_id)
#

require 'rails_helper'

describe Goal, type: :model do
  let(:goal) { create(:goal) }

  it 'has a valid factory' do
    expect(goal).to be_valid
  end

  it 'requires a minute' do
    expect(build(:goal, minute: nil)).not_to be_valid
  end

  it 'requires a player name' do
    expect(build(:goal, player_name: nil)).not_to be_valid
  end

  it 'increments home score if home' do
    goal = create :home_goal
    expect(goal.match.score).to be == '1 - 0'
  end

  it 'increments away score if away' do
    goal = create :away_goal
    expect(goal.match.score).to be == '0 - 1'
  end

  it 'increments away score if home own goal' do
    goal = create :own_home_goal
    expect(goal.match.score).to be == '0 - 1'
  end

  it 'increments home score if away own goal' do
    goal = create :own_away_goal
    expect(goal.match.score).to be == '1 - 0'
  end

  it 'automatically sets player name if player_id set' do
    player = create :player
    player_goal = create :goal, player_id: player.id
    expect(player_goal.player_name).to be == player.name
  end

  it 'changes player name if player_id changed' do
    player = create :player
    player2 = create :player, team: player.team
    player_goal = create :goal, player_id: player.id
    player_goal.update(player_id: player2.id)
    expect(player_goal.player_name).to be == player2.name
  end

  it 'automatically sets assisted by if assist_id set' do
    player = create :player
    player_assist = create :goal, assist_id: player.id
    expect(player_assist.assisted_by).to be == player.name
  end

  it 'changes assisted by if assist_id changed' do
    player = create :player
    player2 = create :player, team: player.team
    player_assist = create :goal, assist_id: player.id
    player_assist.update(assist_id: player2.id)
    expect(player_assist.assisted_by).to be == player2.name
  end

  it 'decrements score if goal is destroyed' do
    match = create :match
    goal = create :home_goal, match: match
    goal.destroy
    expect(match.reload.score).to be == '0 - 0'
  end

  %i[home_goal away_goal own_home_goal own_away_goal].each do |goal_type|
    describe "if #{goal_type}" do
      let(:goal) { create goal_type }

      it 'changes score if home/away is toggled' do
        score = goal.match.score
        goal.update(home: !goal.home)
        expect(goal.match.score).to be == score.reverse
      end

      it 'changes score if own_goal is toggled' do
        score = goal.match.score
        goal.update(own_goal: !goal.own_goal)
        expect(goal.match.score).to be == score.reverse
      end

      it 'does not change score if home/away and own_goal is toggled' do
        score = goal.match.score
        goal.update(home: !goal.home, own_goal: !goal.own_goal)
        expect(goal.match.score).to be == score
      end
    end
  end
end
