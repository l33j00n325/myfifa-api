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

class SquadPlayer < ApplicationRecord
  belongs_to :squad
  belongs_to :player

  validates :pos, inclusion: { in: Cap::POSITIONS }
  validate :same_team?

  def same_team?
    return if squad_id.nil? ||
              player_id.nil? ||
              squad.team_id == player.team_id

    errors.add :base, 'Squad and Player are not of the same Team'
  end

  delegate :team, to: :squad
end
