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

class Squad < ApplicationRecord
  include Broadcastable

  belongs_to :team
  has_many :squad_players, dependent: :destroy
  has_many :players, through: :squad_players

  accepts_nested_attributes_for :squad_players

  validates :name, presence: true
  validates :squad_players, length: { is: 11 }
  validate :unique_positions?
  validate :unique_players?

  def unique_positions?
    return if squad_players.map(&:pos).uniq.size == 11

    errors.add :squad, 'includes at least one Position multiple times'
  end

  def unique_players?
    return if squad_players.map(&:player_id).uniq.size == 11

    errors.add :base, 'includes at least one Player multiple times'
  end

  def store_lineup(match)
    self.squad_players = match.caps.where(start: 0).map do |cap|
      SquadPlayer.new(player_id: cap.player_id, pos: cap.pos)
    end
  end

  def eligible_players
    squad_players.includes(:player).select do |squad_player|
      squad_player.player.active?
    end
  end
end
