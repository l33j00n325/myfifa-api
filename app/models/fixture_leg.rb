# frozen_string_literal: true

# == Schema Information
#
# Table name: fixture_legs
#
#  id         :bigint           not null, primary key
#  away_score :string
#  home_score :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fixture_id :bigint
#
# Indexes
#
#  index_fixture_legs_on_fixture_id  (fixture_id)
#

class FixtureLeg < ApplicationRecord
  include Broadcastable

  belongs_to :fixture

  PERMITTED_ATTRIBUTES = %i[
    id
    _destroy
    home_score
    away_score
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  delegate :team, to: :fixture
end
