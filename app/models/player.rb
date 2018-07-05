# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  nationality :string
#  pos         :string
#  sec_pos     :text
#  ovr         :integer
#  value       :integer
#  birth_year  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :string
#  youth       :boolean          default(TRUE)
#
# Indexes
#
#  index_players_on_team_id  (team_id)
#

class Player < ApplicationRecord
  belongs_to :team
  has_many :player_histories, dependent: :destroy
  has_many :injuries, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :transfers, dependent: :destroy

  STATUSES = %w[
    Pending
    Active
    Injured
    Loaned
  ].freeze

  POSITIONS = %w[
    GK
    CB
    LB
    LWB
    RB
    RWB
    CDM
    CM
    LM
    RM
    LW
    RW
    CAM
    CF
    ST
  ].freeze

  PERMITTED_ATTRIBUTES = %i[
    name
    pos
    ovr
    value
    birth_year
    youth
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  serialize :sec_pos, Array

  ################
  #  VALIDATION  #
  ################

  validates :name, presence: true
  validates :birth_year, numericality: { only_integer: true }
  validates :ovr, numericality: { only_integer: true }
  validates :value, numericality: { only_integer: true }
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

  after_create :start_history
  after_update :update_history

  def start_history
    player_histories.create ovr: ovr,
                            value: value
  end

  def update_history
    record = player_histories.new
    record.ovr = ovr if saved_change_to_ovr?
    record.value = value if saved_change_to_value?
    record.save!
  end

  ##############
  #  MUTATORS  #
  ##############

    def update_status
      self.status =
        if active_loan
          'Loaned'
        elsif active_injury
          'Injured'
        elsif active_contract
          active_contract.pending? ? 'Pending' : 'Active'
        else
          nil
        end
      save!
    end


  ###############
  #  ACCESSORS  #
  ###############

  delegate :current_date, to: :team

  %w[ active pending injured loaned ].each do |condition|
    define_method "#{condition}?" do
      status == condition.capitalize
    end
  end

  def as_json(options = {})
    super((options || {}).merge({
      methods: %i[age active_contract active_injury active_loan active_transfer]
    }))
  end

  %w[contract injury loan transfer].each do |record|
    define_method "active_#{record}" do
      last_record = public_send(record.pluralize).last
      last_record if last_record && last_record.active?
    end
  end

  def age
    current_date.year - birth_year
  end
end
