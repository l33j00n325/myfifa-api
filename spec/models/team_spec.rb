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

require 'rails_helper'

describe Team, type: :model do
  let(:team) { create :team }

  it 'has a valid factory' do
    expect(team).to be_valid
  end

  it 'requires a name' do
    expect(build(:team, name: nil)).not_to be_valid
  end

  it 'requires a start date' do
    expect(build(:team, started_on: nil)).not_to be_valid
  end

  it 'requires a currency' do
    expect(build(:team, currency: nil)).not_to be_valid
  end

  it '#badge_path returns the path for the attached badge' do
    team.badge.attach io: File.open(Rails.root.join('public/robots.txt')),
                      filename: 'test.txt'
    expect(team.badge_path).to be_present
  end

  it '#opponents collects all teams from matches' do
    create_list :match, 10, team: team
    expect(team.opponents)
      .to be == team.matches.reload.pluck(:home, :away).flatten.uniq.sort
  end
end
