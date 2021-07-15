# frozen_string_literal: true

# == Schema Information
#
# Table name: penalty_shootouts
#
#  id         :bigint           not null, primary key
#  away_score :integer
#  home_score :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint
#
# Indexes
#
#  index_penalty_shootouts_on_match_id  (match_id)
#

require 'rails_helper'

describe PenaltyShootout, type: :model do
  it 'has a valid factory' do
    expect(create(:penalty_shootout)).to be_valid
  end

  it 'requires a home score' do
    expect(build(:penalty_shootout, home_score: nil)).not_to be_valid
  end

  it 'requires an away score' do
    expect(build(:penalty_shootout, away_score: nil)).not_to be_valid
  end

  it 'must have a winner' do
    score = Faker::Number.between(from: 0, to: 20)
    expect(
      build(:penalty_shootout, home_score: score, away_score: score)
    ).not_to be_valid
  end
end
