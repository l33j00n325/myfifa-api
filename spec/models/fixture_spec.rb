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

require 'rails_helper'

RSpec.describe Fixture, type: :model do
  let(:fixture) { FactoryBot.create(:fixture) }

  it 'has a valid factory' do
    expect(fixture).to be_valid
  end

  it 'requires at least one FixtureLeg' do
    expect(FactoryBot.build(:fixture, legs_count: 0)).to_not be_valid
  end
end
