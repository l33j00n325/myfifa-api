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

class TableRow < ApplicationRecord
  include Broadcastable

  default_scope do
    order Arel.sql('(3 * wins + draws) DESC,'\
                   '(goals_for - goals_against) DESC,'\
                   'goals_for DESC')
  end

  belongs_to :stage

  validates :name, presence: true, on: :update
  validates :wins, presence: true
  validates :draws, presence: true
  validates :losses, presence: true
  validates :goals_for, presence: true
  validates :goals_against, presence: true

  delegate :team, to: :stage

  def goal_difference
    goals_for - goals_against
  end

  def points
    3 * wins + draws
  end

  def as_json(options = {})
    options[:methods] ||= []
    options[:methods] += %i[goal_difference points]
    super
  end
end
