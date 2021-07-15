# frozen_string_literal: true

# == Schema Information
#
# Table name: squads
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_squads_on_team_id  (team_id)
#

FactoryBot.define do
  factory :squad do
    name { Faker::Lorem.word }
    association :team, factory: :team_with_players

    transient do
      players_count { 11 }
    end

    before :create do |squad, evaluator|
      Cap::POSITIONS.dup.sample(evaluator.players_count).each do |pos|
        player = create :player, team: squad.team
        squad_player = create :squad_player,
                              squad: squad,
                              player: player,
                              pos: pos
        squad.squad_players << squad_player
      end
    end
  end
end
