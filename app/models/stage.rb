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

class Stage < ApplicationRecord
  include Broadcastable

  default_scope { order(num_teams: :desc, id: :asc) }
  belongs_to :competition
  has_many :table_rows, dependent: :destroy
  has_many :fixtures, dependent: :destroy

  validates :name, presence: true
  validates :num_teams, numericality: { greater_than: 0 }
  validates :num_fixtures, numericality: { greater_than: 0 }, unless: :table?

  after_create :create_items

  def create_items
    if table?
      num_teams.times { table_rows.create! }
    else
      num_fixtures.times do
        fixture = fixtures.new
        fixture.legs << FixtureLeg.new
        fixture.save!
      end
    end
  end

  def num_teams=(val)
    super
    self.name ||=
      case num_teams
      when 8 then 'Quarter-Finals'
      when 4 then 'Semi-Finals'
      when 2 then 'Final'
      else "Round of #{num_teams}"
      end
  end

  delegate :team, to: :competition
end
