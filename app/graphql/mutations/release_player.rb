# frozen_string_literal: true

module Mutations
  class ReleasePlayer < Mutations::BaseMutation
    argument :id, ID, required: true

    field :player, Types::Myfifa::PlayerType, null: false

    def resolve(id:)
      current_ability = Ability.new(context[:current_user])
      player = Player.accessible_by(current_ability).find(id)
      player.current_contract&.terminate!
      { player: player }
    end
  end
end
