# frozen_string_literal: true

# == Schema Information
#
# Table name: fixtures
#
#  id         :bigint           not null, primary key
#  away_team  :string
#  home_team  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stage_id   :bigint
#
# Indexes
#
#  index_fixtures_on_stage_id  (stage_id)
#

FactoryBot.define do
  factory :fixture do
    home_team { Faker::Team.name }
    away_team { Faker::Team.name }
    stage

    transient do
      legs_count { 1 }
    end

    before :create do |fixture, evaluator|
      evaluator.legs_count.times do
        fixture.legs.build
      end
    end

    factory :completed_fixture do
      home_team { Faker::Team.name }
      away_team { Faker::Team.name }
      # home_score { Faker::Number.between(0, 3) }
      # away_score { Faker::Number.between(0, 3) }
    end
  end
end
