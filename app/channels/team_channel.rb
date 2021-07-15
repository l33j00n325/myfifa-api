# frozen_string_literal: true

class TeamChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_user
    current_ability = Ability.new(current_user)
    team = Team.accessible_by(current_ability).find(params[:id])
    stream_for team
  end
end
