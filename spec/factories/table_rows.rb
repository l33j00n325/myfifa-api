# frozen_string_literal: true

# == Schema Information
#
# Table name: table_rows
#
#  id            :bigint           not null, primary key
#  draws         :integer          default(0)
#  goals_against :integer          default(0)
#  goals_for     :integer          default(0)
#  losses        :integer          default(0)
#  name          :string
#  wins          :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stage_id      :bigint
#
# Indexes
#
#  index_table_rows_on_stage_id  (stage_id)
#

FactoryBot.define do
  factory :table_row do
    name { Faker::Team.name }
    stage
  end
end
