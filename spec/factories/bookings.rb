# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  minute      :integer
#  player_name :string
#  red_card    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  match_id    :bigint
#  player_id   :bigint
#
# Indexes
#
#  index_bookings_on_match_id   (match_id)
#  index_bookings_on_player_id  (player_id)
#

FactoryBot.define do
  factory :booking do
    minute { Faker::Number.between(from: 1, to: 120) }
    player
    match
  end
end
