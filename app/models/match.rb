# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id          :bigint(8)        not null, primary key
#  team_id     :bigint(8)
#  home        :string
#  away        :string
#  competition :string
#  date_played :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  extra_time  :boolean          default(FALSE)
#  home_score  :integer
#  away_score  :integer
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#

class Match < ApplicationRecord
  belongs_to :team
  has_one :penalty_shootout, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :substitutions, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many :caps, dependent: :destroy
  has_many :players, through: :caps

  PERMITTED_ATTRIBUTES = %i[
    home
    away
    competition
    extra_time
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  scope :with_players, -> { includes(caps: :player) }

  ################
  #  VALIDATION  #
  ################

  validates :home, presence: true
  validates :away, presence: true
  validates :competition, presence: true
  validates :date_played, presence: true
  validate :different_teams

  def different_teams
    errors.add(:away, 'must differ from Home') if home == away
  end

  ##############
  #  CALLBACK  #
  ##############

  before_validation :set_defaults
  after_save :set_cap_stop_times, if: :extra_time_changed?

  def set_defaults
    self.date_played ||= team.current_date
    self.home_score ||= 0
    self.away_score ||= 0
  end

  def set_cap_stop_times
    caps
      .where(subbed_out: false)
      .update_all(extra_time? ? 120 : 90)
  end

  ##############
  #  MUTATORS  #
  ##############

  def apply(squad)
    Cap.transaction do
      # Remove existing Caps
      caps.map(&:destroy)

      # Add new Caps from Squad player list
      squad.players_list.each_with_index do |player_id, i|
        caps.create player_id: player_id,
                    pos: squad.positions_list[i]
      end
    end

    # Reload association to include new Caps
    caps.reload
  end

  ###############
  #  ACCESSORS  #
  ###############

  def team_played?
    [home, away].include? team.title
  end

  def team_home?
    team.title == home
  end

  def team_score
    team_home? ? home_score : away_score
  end

  def other_score
    team_home? ? away_score : home_score
  end

  def team_result
    return unless team_played?

    if team_score > other_score     then 'win'
    elsif team_score == other_score then 'draw'
    else 'loss'
    end
  end

  def score
    score = home_score.to_s
    score += " (#{penalty_shootout.home_score})" if penalty_shootout
    score += ' - '
    score += away_score.to_s
    score += " (#{penalty_shootout.away_score})" if penalty_shootout
    score
  end

  def winner
    if home_score > away_score    then home
    elsif home_score < away_score then away
    elsif penalty_shootout        then penalty_shootout.winner
    end
  end

  def events
    [*goals, *substitutions, *bookings].sort_by(&:minute)
  end

  def as_json(options = {})
    options[:methods] ||= []
    options[:methods] += %i[
      score
      team_result
      penalty_shootout
    ]
    super
  end

  def full_json
    as_json methods: %i[events caps]
  end
end
