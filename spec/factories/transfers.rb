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

FactoryBot.define do
  factory :transfer do
    origin { Faker::Team.unique.name }
    destination { Faker::Team.unique.name }
    moved_on { Faker::Date.between(from: Time.zone.today, to: 60.days.from_now) }
    player
  end
end
