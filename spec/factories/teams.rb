# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE), not null
#  currency     :string           default("$")
#  currently_on :date
#  name         :string
#  started_on   :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
# Indexes
#
#  index_teams_on_user_id  (user_id)
#

FactoryBot.define do
  factory :team do
    name { Faker::Team.name }
    started_on { Time.zone.today }
    user

    before(:create) do |team|
      team.currently_on = team.started_on
    end

    factory :team_with_players do
      transient do
        players_count { 11 }
      end

      after :create do |team, evaluator|
        create_list :player, evaluator.players_count, team: team
      end
    end
  end
end
