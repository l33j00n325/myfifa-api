# frozen_string_literal: true

# == Schema Information
#
# Table name: caps
#
#  id         :bigint           not null, primary key
#  pos        :string
#  rating     :integer
#  start      :integer          default(0)
#  stop       :integer          default(90)
#  subbed_out :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint
#  player_id  :bigint
#
# Indexes
#
#  index_caps_on_match_id                    (match_id)
#  index_caps_on_player_id                   (player_id)
#  index_caps_on_player_id_and_match_id      (player_id,match_id) UNIQUE
#  index_caps_on_pos_and_match_id_and_start  (pos,match_id,start) UNIQUE
#

FactoryBot.define do
  factory :cap do
    pos { Cap::POSITIONS.sample }
    start { Faker::Number.between(from: 0, to: 90) }
    stop { Faker::Number.between(from: start || 0, to: 90) }
    player
    match { Match.new(attributes_for(:match, team_id: player.team_id)) }
  end
end
