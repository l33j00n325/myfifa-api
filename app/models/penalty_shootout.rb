# frozen_string_literal: true

# == Schema Information
#
# Table name: penalty_shootouts
#
#  id         :bigint           not null, primary key
#  away_score :integer
#  home_score :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint
#
# Indexes
#
#  index_penalty_shootouts_on_match_id  (match_id)
#

class PenaltyShootout < ApplicationRecord
  include Broadcastable

  belongs_to :match

  validates :home_score, numericality: { only_integer: true }
  validates :away_score, numericality: { only_integer: true }
  validate :no_draw?

  def no_draw?
    return if home_score != away_score

    errors.add :base, 'Penalty Shootout must have a winner'
  end

  delegate :team, to: :match
end
