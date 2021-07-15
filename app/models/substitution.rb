# frozen_string_literal: true

# == Schema Information
#
# Table name: substitutions
#
#  id             :bigint           not null, primary key
#  injury         :boolean          default(FALSE), not null
#  minute         :integer
#  player_name    :string
#  replaced_by    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  match_id       :bigint
#  player_id      :bigint
#  replacement_id :bigint
#
# Indexes
#
#  index_substitutions_on_match_id        (match_id)
#  index_substitutions_on_player_id       (player_id)
#  index_substitutions_on_replacement_id  (replacement_id)
#

class Substitution < ApplicationRecord
  include Broadcastable

  belongs_to :match
  belongs_to :player
  belongs_to :replacement, class_name: 'Player'

  validates :minute, inclusion: 1..120

  before_validation :set_names
  after_create :create_cap
  after_update :update_subbed_cap, if: :saved_change_to_player_id?
  after_update :update_sub_cap, if: :saved_change_to_replacement_id?
  after_destroy :delete_cap

  def set_names
    self.player_name = player.name if player_id.present?
    self.replaced_by = replacement.name if replacement_id.present?
  end

  def create_cap
    return unless subbed_cap

    subbed_cap.update(stop: minute, subbed_out: true)
    match.caps.create player_id: replacement_id,
                      pos: subbed_cap.pos,
                      start: minute,
                      stop: match_stop
  end

  def update_subbed_cap
    match
      .caps
      .find_by(player_id: player_id_before_last_save)
      .update(stop: match_stop, subbed_out: false)
    subbed_cap.update(stop: minute, subbed_out: true)
  end

  def update_sub_cap
    match
      .caps
      .find_by(player_id: replacement_id_before_last_save)
      .update(player_id: replacement_id)
  end

  def delete_cap
    sub_cap&.destroy
    subbed_cap&.update(stop: match_stop, subbed_out: false)
  end

  delegate :team, to: :match

  def subbed_cap
    match.caps.find_by(player_id: player_id)
  end

  def sub_cap
    match.caps.find_by(player_id: replacement_id)
  end

  def match_stop
    match.extra_time? ? 120 : 90
  end
end
