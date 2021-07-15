# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id          :bigint           not null, primary key
#  birth_year  :integer
#  kit_no      :integer
#  name        :string
#  nationality :string
#  ovr         :integer
#  pos         :string
#  sec_pos     :text             default([]), is an Array
#  status      :string
#  value       :integer
#  youth       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_players_on_team_id  (team_id)
#

class Player < ApplicationRecord
  include Broadcastable

  belongs_to :team
  has_many :histories,
           class_name: 'PlayerHistory',
           inverse_of: :player,
           dependent: :destroy
  has_many :injuries, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :transfers, dependent: :destroy

  has_many :caps, dependent: :destroy
  has_many :matches, through: :caps

  has_many :goals, dependent: :destroy
  has_many :assists,
           class_name: 'Goal',
           foreign_key: :assist_id,
           inverse_of: :assisting_player,
           dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many :squad_players, dependent: :destroy
  has_many :squads, through: :squad_players

  accepts_nested_attributes_for :contracts

  STATUSES = %w[
    Pending
    Active
    Injured
    Loaned
  ].freeze

  POSITIONS = %w[
    GK
    RB
    RWB
    CB
    LB
    LWB
    RM
    CDM
    CM
    CAM
    LM
    RW
    CF
    ST
    LW
  ].freeze

  ################
  #  VALIDATION  #
  ################

  validates :name, presence: true
  validates :birth_year, numericality: { greater_than: 0, only_integer: true }
  validates :ovr, inclusion: 0..100
  validates :value, numericality: { greater_than: 0, only_integer: true }
  validates :kit_no, numericality: { only_integer: true }, allow_nil: true
  validates :pos, inclusion: { in: POSITIONS }
  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  validate :valid_sec_pos

  def valid_sec_pos
    return if sec_pos.nil?

    sec_pos.each do |pos|
      next if POSITIONS.include?(pos)

      errors.add(:sec_pos, "#{pos} is not a valid Position")
    end
  end

  ##############
  #  CALLBACK  #
  ##############

  before_save :set_kit_no, if: :status_changed?
  after_create :save_history
  after_update :update_history
  after_update :end_pending_injuries, unless: :injured?
  after_update :set_contract_conclusion, if: :saved_change_to_status?

  def set_kit_no
    self.kit_no = nil if status.blank? || loaned?
  end

  def save_history
    histories.create ovr: ovr,
                     value: value,
                     kit_no: kit_no
  end

  def update_history
    save_history if saved_change_to_ovr? || saved_change_to_value?
  end

  def end_pending_injuries
    injuries.where(ended_on: nil).update(ended_on: currently_on)
  end

  def set_contract_conclusion
    return if status.present?

    last_contract&.update(conclusion: last_contract.conclusion || 'Expired')
  end

  ##############
  #  MUTATORS  #
  ##############

  def update_status
    update status:
      if current_contract.nil?        then nil
      elsif current_loan&.loaned_out? then 'Loaned'
      elsif current_injury            then 'Injured'
      elsif current_contract.pending? then 'Pending'
      else 'Active'
      end
  end

  def age=(val)
    self[:birth_year] = team.currently_on.year - val.to_i if team.present?
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :currently_on, to: :team

  %w[active pending injured loaned].each do |condition|
    define_method "#{condition}?" do
      status == condition.capitalize
    end
  end

  %w[contract injury loan].each do |record|
    define_method "last_#{record}" do
      public_send(record.pluralize).last
    end

    define_method "current_#{record}" do
      last_record = public_send("last_#{record}")
      last_record if last_record&.current?
    end
  end

  def age
    currently_on.year - birth_year
  end

  def as_json(options = {})
    options[:methods] ||= []
    options[:methods] += %i[age]
    super
  end
end
