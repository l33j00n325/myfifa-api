# == Schema Information
#
# Table name: match_events
#
#  id          :integer          not null, primary key
#  match_id    :integer
#  parent_id   :integer
#  type        :string
#  minute      :integer
#  player_name :string
#  player_id   :integer
#  detail      :string
#  home        :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_match_events_on_match_id   (match_id)
#  index_match_events_on_parent_id  (parent_id)
#  index_match_events_on_player_id  (player_id)
#

FactoryBot.define do
  factory :match_event do
    
  end
end