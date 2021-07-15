# frozen_string_literal: true

module Mutations
  class ApplySquadToMatch < Mutations::BaseMutation
    argument :match_id, ID, required: true
    argument :squad_id, ID, required: true

    field :match, Types::Myfifa::MatchType, null: false

    def resolve(match_id:, squad_id:)
      current_ability = Ability.new(context[:current_user])
      match = Match.accessible_by(current_ability).find(match_id)
      squad = Squad.accessible_by(current_ability).find(squad_id)
      match.apply squad
      { match: match }
    end
  end
end
