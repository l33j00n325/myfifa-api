# frozen_string_literal: true

# == Schema Information
#
# Table name: squad_players
#
#  id         :bigint           not null, primary key
#  pos        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :bigint
#  squad_id   :bigint
#
# Indexes
#
#  index_squad_players_on_player_id  (player_id)
#  index_squad_players_on_squad_id   (squad_id)
#

FactoryBot.define do
  factory :squad_player do
    pos { Cap::POSITIONS.sample }
    player
    squad { Squad.new(attributes_for(:squad, team_id: player.team_id)) }
  end
end
