# frozen_string_literal: true

module Mutations
  class StoreMatchLineupToSquad < Mutations::BaseMutation
    argument :match_id, ID, required: true
    argument :squad_id, ID, required: true

    field :squad, Types::Myfifa::SquadType, null: false

    def resolve(match_id:, squad_id:)
      current_ability = Ability.new(context[:current_user])
      match = Match.accessible_by(current_ability).find(match_id)
      squad = Squad.accessible_by(current_ability).find(squad_id)
      squad.store_lineup match
      { squad: squad }
    end
  end
end
