# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id          :bigint           not null, primary key
#  away        :string
#  away_score  :integer          default(0)
#  competition :string
#  extra_time  :boolean          default(FALSE), not null
#  friendly    :boolean          default(FALSE), not null
#  home        :string
#  home_score  :integer          default(0)
#  played_on   :date
#  season      :integer
#  stage       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#

class Match < ApplicationRecord
  include Broadcastable

  belongs_to :team
  has_one :penalty_shootout, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :substitutions, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many :caps, dependent: :destroy
  has_many :players, through: :caps

  accepts_nested_attributes_for :penalty_shootout,
                                allow_destroy: true,
                                update_only: true

  ################
  #  VALIDATION  #
  ################

  validates :home, presence: true
  validates :away, presence: true
  validates :competition, presence: true, unless: :friendly?
  validates :played_on, presence: true
  validate :different_teams

  def different_teams
    errors.add(:away, 'must differ from Home') if home == away
  end

  ##############
  #  CALLBACK  #
  ##############

  before_create :set_season
  after_save :increment_currently_on, if: :saved_change_to_played_on?
  after_save :set_cap_stop_times, if: :saved_change_to_extra_time?

  def set_season
    self.season = ((played_on - team.started_on) / 365).to_i
  end

  def increment_currently_on
    return if currently_on >= played_on

    team.update(currently_on: played_on)
  end

  def set_cap_stop_times
    caps.where(subbed_out: false).find_each do |cap|
      cap.update(stop: extra_time? ? 120 : 90)
    end
  end

  ##############
  #  MUTATORS  #
  ##############

  def apply(squad)
    self.caps = squad.eligible_players.map do |squad_player|
      Cap.new(player_id: squad_player.player_id, pos: squad_player.pos)
    end
  end

  ###############
  #  ACCESSORS  #
  ###############

  delegate :currently_on, to: :team

  def team_played?
    [home, away].include? team.name
  end

  def team_home?
    team.name == home
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

  def as_json(options = {})
    options[:methods] ||= []
    options[:methods] += %i[
      score
      team_result
    ]
    super
  end
end
