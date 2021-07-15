# frozen_string_literal: true

# == Schema Information
#
# Table name: player_histories
#
#  id          :bigint           not null, primary key
#  kit_no      :integer
#  ovr         :integer
#  recorded_on :date
#  value       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#
# Indexes
#
#  index_player_histories_on_player_id  (player_id)
#

require 'rails_helper'

describe PlayerHistory, type: :model do
  it 'has a valid factory' do
    expect(create(:player_history)).to be_valid
  end

  it 'requires a datestamp' do
    expect(build(:player_history, recorded_on: nil)).not_to be_valid
  end

  it 'requires an overall rating' do
    expect(build(:player_history, ovr: nil)).not_to be_valid
  end

  it 'requires a value' do
    expect(build(:player_history, value: nil)).not_to be_valid
  end
end
