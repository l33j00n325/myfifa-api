# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id          :bigint           not null, primary key
#  away        :string
#  away_score  :integer
#  competition :string
#  extra_time  :boolean          default(FALSE), not null
#  friendly    :boolean          default(FALSE), not null
#  home        :string
#  home_score  :integer
#  played_on   :date
#  stage       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#

FactoryBot.define do
  factory :match do
    home { Faker::Team.unique.name }
    away { Faker::Team.unique.name }
    competition { Faker::Lorem.word }
    played_on { Faker::Date.between(from: Date.today, to: 60.days.from_now) }
    team
  end
end
