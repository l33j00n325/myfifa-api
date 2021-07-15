# frozen_string_literal: true

# == Schema Information
#
# Table name: injuries
#
#  id          :bigint           not null, primary key
#  description :string
#  ended_on    :date
#  started_on  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#
# Indexes
#
#  index_injuries_on_player_id  (player_id)
#

class Injury < ApplicationRecord
  include Broadcastable

  belongs_to :player

  scope :active, -> { where(ended_on: nil) }

  #################
  #  VALIDATIONS  #
  #################

  validates :description, presence: true
  validates :started_on, presence: true
  validates :ended_on,
            date: { after_or_equal_to: :started_on },
            allow_nil: true
  validate :no_double_injury, on: :create

  def no_double_injury
    return unless player.injured?

    errors.add :base, 'Player can not be injured when already injured.'
  end

  ###############
  #  CALLBACKS  #
  ###############

  before_validation :set_started_on
  after_save :update_status

  def set_started_on
    self.started_on ||= team.currently_on
  end

  ##############
  #  MUTATORS  #
  ##############

  delegate :update_status, to: :player

  def recovered=(val)
    self.ended_on = team.currently_on if player_id && val
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :team, to: :player

  def current?
    started_on <= team.currently_on &&
      (ended_on.nil? || team.currently_on < ended_on)
  end
end
