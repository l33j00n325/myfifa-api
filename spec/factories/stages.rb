# frozen_string_literal: true

# == Schema Information
#
# Table name: stages
#
#  id             :bigint           not null, primary key
#  name           :string
#  num_fixtures   :integer
#  num_teams      :integer
#  table          :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :bigint
#
# Indexes
#
#  index_stages_on_competition_id  (competition_id)
#

FactoryBot.define do
  factory :stage do
    num_teams { Faker::Number.between(from: 1, to: 20) }
    num_fixtures { 2**Faker::Number.between(from: 1, to: 5) }
    competition
  end
end
