# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  home        :boolean          default(FALSE), not null
#  minute      :integer
#  player_name :string
#  red_card    :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  match_id    :bigint
#  player_id   :bigint
#
# Indexes
#
#  index_bookings_on_match_id   (match_id)
#  index_bookings_on_player_id  (player_id)
#

require 'rails_helper'

describe Booking, type: :model do
  let(:booking) { create(:booking) }

  it 'has a valid factory' do
    expect(booking).to be_valid
  end

  it 'requires a minute' do
    expect(build(:booking, minute: nil)).not_to be_valid
  end

  it 'automatically sets player name if player_id set' do
    player = create(:player)
    player_booking = create :booking, player_id: player.id
    expect(player_booking.player_name).to be == player.name
  end

  it 'changes player name if player_id changed' do
    player = create :player
    player2 = create :player, team: player.team
    player_booking = create :booking, player_id: player.id
    player_booking.update(player_id: player2.id)
    expect(player_booking.player_name).to be == player2.name
  end
end
