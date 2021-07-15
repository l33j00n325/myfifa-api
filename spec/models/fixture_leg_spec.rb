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

require 'rails_helper'

describe FixtureLeg, type: :model do
  let(:fixture_leg) { create(:fixture_leg) }

  it 'has a valid factory' do
    expect(fixture_leg).to be_valid
  end
end
