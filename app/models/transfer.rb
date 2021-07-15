# frozen_string_literal: true

# == Schema Information
#
# Table name: transfers
#
#  id            :bigint           not null, primary key
#  addon_clause  :integer
#  destination   :string
#  fee           :integer
#  moved_on      :date
#  origin        :string
#  signed_on     :date
#  traded_player :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  player_id     :bigint
#
# Indexes
#
#  index_transfers_on_player_id  (player_id)
#

class Transfer < ApplicationRecord
  include Broadcastable

  belongs_to :player

  ################
  #  VALIDATION  #
  ################

  validates :origin, presence: true
  validates :destination, presence: true
  validates :moved_on, presence: true
  validates :addon_clause,
            inclusion: { in: 0..100 },
            allow_nil: true

  ###############
  #  CALLBACKS  #
  ###############

  before_validation :set_signed_on
  after_create :end_current_contract, if: :out?

  def set_signed_on
    self.signed_on ||= team.currently_on
  end

  def end_current_contract
    return if player.contracts.none?

    player.contracts.last.update(ended_on: moved_on, conclusion: 'Transferred')
    player.update_status
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :team, to: :player

  def out?
    team.name == origin
  end
end
