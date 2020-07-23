# frozen_string_literal: true

# == Schema Information
#
# Table name: goals
#
#  id          :bigint           not null, primary key
#  assisted_by :string
#  home        :boolean          default(FALSE)
#  minute      :integer
#  own_goal    :boolean          default(FALSE)
#  penalty     :boolean          default(FALSE)
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

class Goal < ApplicationRecord
  include Broadcastable

  belongs_to :match
  belongs_to :player, optional: true
  belongs_to :assisting_player,
             foreign_key: :assist_id,
             class_name: 'Player',
             optional: true,
             inverse_of: :assists

  PERMITTED_ATTRIBUTES = %i[
    minute
    player_name
    player_id
    assisted_by
    assist_id
    home
    own_goal
    penalty
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  validates :minute, inclusion: 1..120
  validates :player_name, presence: true

  before_validation :set_names
  after_create :increment_score
  after_destroy :decrement_score
  after_update :update_score, if: :score_changed?

  def set_names
    self.player_name = player.name if player_id.present?
    self.assisted_by = assisting_player.name if assist_id.present?
  end

  def increment_score
    if home? ^ own_goal?
      match.home_score += 1
    else
      match.away_score += 1
    end
    match.save!
  end

  def decrement_score
    if home? ^ own_goal?
      match.home_score -= 1
    else
      match.away_score -= 1
    end
    match.save!
  end

  def update_score
    if home? == own_goal?
      match.home_score -= 1
      match.away_score += 1
    else
      match.home_score += 1
      match.away_score -= 1
    end
    match.save!
  end

  def score_changed?
    saved_change_to_home? != saved_change_to_own_goal? &&
      (saved_change_to_home? || saved_change_to_own_goal?)
  end

  delegate :team, to: :match

  def away?
    !home?
  end
end
