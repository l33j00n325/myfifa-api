# frozen_string_literal: true

module Mutations
  module UpdateMutations
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
      Player
      Squad
      Stage
      Substitution
      TableRow
      Team
      Transfer
    ].each do |model|
      update_mutation = Class.new(BaseMutation) do
        argument :id, GraphQL::Types::ID, required: true
        argument :attributes,
                 Types::Inputs.const_get("#{model}Attributes"),
                 required: true

        field model.underscore.to_sym,
              Types::Myfifa.const_get("#{model}Type"),
              null: true
        field :errors, Types::ValidationErrorsType, null: true

        define_method :resolve do |id:, attributes:|
          current_ability = Ability.new(context[:current_user])
          record = model.constantize.find(id)

          if current_ability.can? :update, record
            if record.update(attributes.to_h)
              { model.underscore.to_sym => record }
            else
              { errors: record.errors }
            end
          else
            raise CanCan::AccessDenied(nil, :update, record)
          end
        end
      end

      const_set("Update#{model}", update_mutation)
    end
  end
end
