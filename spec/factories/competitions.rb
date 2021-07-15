# frozen_string_literal: true

# == Schema Information
#
# Table name: competitions
#
#  id         :bigint           not null, primary key
#  champion   :string
#  name       :string
#  season     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_competitions_on_season   (season)
#  index_competitions_on_team_id  (team_id)
#

FactoryBot.define do
  factory :competition do
    season { Faker::Number.digit }
    name { Faker::Lorem.word }
    team

    factory :league do
      preset_format { 'League' }
      num_teams { Faker::Number.between(from: 2, to: 100) }
    end

    factory :cup do
      preset_format { 'Knockout' }
      num_teams { 2**Faker::Number.between(from: 1, to: 6) }
    end

    factory :tournament do
      preset_format { 'Group + Knockout' }
    end
  end
end
