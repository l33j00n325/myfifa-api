# frozen_string_literal: true

# == Schema Information
#
# Table name: contracts
#
#  id                :bigint           not null, primary key
#  bonus_req         :integer
#  bonus_req_type    :string
#  conclusion        :string
#  ended_on          :date
#  performance_bonus :integer
#  release_clause    :integer
#  signed_on         :date
#  signing_bonus     :integer
#  started_on        :date
#  wage              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  player_id         :bigint
#
# Indexes
#
#  index_contracts_on_player_id  (player_id)
#

class Contract < ApplicationRecord
  include Broadcastable

  belongs_to :player

  BONUS_REQUIREMENT_TYPES = [
    'Appearances',
    'Goals',
    'Assists',
    'Clean Sheets'
  ].freeze

  CONCLUSION_TYPES = %w[
    Renewed
    Transferred
    Expired
    Released
    Retired
  ].freeze

  ################
  #  VALIDATION  #
  ################

  validates :signed_on, presence: true
  validates :started_on,
            date: {
              after_or_equal_to: :signed_on,
              before_or_equal_to: :ended_on
            }
  validates :ended_on, presence: true
  validates :wage, numericality: { only_integer: true }
  validates :bonus_req_type,
            inclusion: { in: BONUS_REQUIREMENT_TYPES },
            allow_nil: true
  validates :conclusion,
            inclusion: { in: CONCLUSION_TYPES },
            allow_nil: true
  validate  :valid_performance_bonus

  def valid_performance_bonus
    return if [performance_bonus, bonus_req, bonus_req_type].all? ||
              [performance_bonus, bonus_req, bonus_req_type].none?

    errors.add(:performance_bonus, 'requires all three fields')
  end

  ##############
  #  CALLBACK  #
  ##############

  before_validation :set_signed_on
  after_create :close_previous_contract
  after_create :update_status

  def set_signed_on
    self.signed_on ||= currently_on
  end

  def close_previous_contract
    Contract
      .where(player_id: player_id)
      .where('ended_on > ?', started_on)
      .where.not(id: id)
      .find_each do |contract|
        contract.update!(ended_on: started_on, conclusion: 'Renewed')
      end
  end

  ##############
  #  MUTATORS  #
  ##############

  delegate :update_status, to: :player

  def terminate!
    update(ended_on: currently_on, conclusion: 'Released')
  end

  def retire!
    update(ended_on: team.end_of_season + 1.day, conclusion: 'Retired')
  end

  def num_seasons=(val)
    return if val.blank?

    num_years = ((started_on - team.started_on) / 365).round + val
    self.ended_on = team.started_on + num_years.years
    @num_seasons_set = true
  end

  def ended_on=(val)
    super unless @num_seasons_set
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :team, :currently_on, to: :player

  def current?
    pending? || active?
  end

  def active?
    started_on <= currently_on && currently_on < ended_on
  end

  def pending?
    signed_on <= currently_on && currently_on < started_on
  end
end
