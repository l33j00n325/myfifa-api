# == Schema Information
#
# Table name: transfers
#
#  id             :integer          not null, primary key
#  player_id      :integer
#  signed_date    :date
#  effective_date :date
#  origin         :string
#  destination    :string
#  fee            :integer
#  traded_player  :string
#  addon_clause   :integer
#  loan           :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_transfers_on_player_id  (player_id)
#

class Transfer < ApplicationRecord
  belongs_to :player

  PERMITTED_ATTRIBUTES = %i[
    signed_date
    effective_date
    origin
    destination
    fee
    traded_player
    loan
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  ################
  #  VALIDATION  #
  ################

  validates :addon_clause,
            inclusion: { in: 0..100 },
            allow_nil: true

  ###############
  #  CALLBACKS  #
  ###############

  after_initialize :set_signed_date
  after_save :set_player_status

  def set_signed_date
    self.signed_date = team.current_date
  end

  def set_player_status
    player.update(status: nil) if out?
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :team, to: :player

  def out?
    team.title == origin
  end

end