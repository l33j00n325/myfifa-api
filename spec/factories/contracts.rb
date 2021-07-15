# frozen_string_literal: true

# == Schema Information
#
# Table name: contracts
#
#  id                :bigint           not null, primary key
#  bonus_req         :integer
#  bonus_req_type    :string
#  conclusion        :string
#  ended_on          :date
#  performance_bonus :integer
#  release_clause    :integer
#  signed_on         :date
#  signing_bonus     :integer
#  started_on        :date
#  wage              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  player_id         :bigint
#
# Indexes
#
#  index_contracts_on_player_id  (player_id)
#

FactoryBot.define do
  factory :contract do
    started_on { Time.zone.today }
    ended_on do
      Faker::Date.between(from: 365.days.from_now, to: 1000.days.from_now)
    end
    wage { Faker::Number.between(from: 1_000, to: 10_000_000) }
    player
  end
end
