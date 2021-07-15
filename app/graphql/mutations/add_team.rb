# frozen_string_literal: true

module Mutations
  class AddTeam < Mutations::BaseMutation
    argument :attributes, Types::Inputs::TeamAttributes, required: true

    field :team, Types::Myfifa::TeamType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(attributes:)
      team = context[:current_user].teams.new(attributes.to_h)

      if team.save
        { team: team }
      else
        { errors: team.errors }
      end
    end
  end
end
