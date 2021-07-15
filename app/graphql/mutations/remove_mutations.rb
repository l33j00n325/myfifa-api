# frozen_string_literal: true

module Mutations
  module RemoveMutations
    %w[
      Booking
      Cap
      Competition
      Contract
      Fixture
      Goal
      Injury
      Loan
      Match
      PenaltyShootout
      Player
      Squad
      Stage
      Substitution
      TableRow
      Team
      Transfer
    ].each do |klass|
      remove_mutation = Class.new(BaseMutation) do
        argument :id, GraphQL::Types::ID, required: true

        field klass.underscore.to_sym,
              Types::Myfifa.const_get("#{klass}Type"),
              null: true
        field :errors, Types::ValidationErrorsType, null: true

        define_method :resolve do |id:|
          current_ability = Ability.new(context[:current_user])
          record = klass.constantize.accessible_by(current_ability).find(id)

          if record.destroy
            { klass.underscore.to_sym => record }
          else
            { errors: record.errors }
          end
        end
      end

      const_set("Remove#{klass}", remove_mutation)
    end
  end
end
