# frozen_string_literal: true

module Mutations
  module AddMutations
    {
      'Team' => %w[Competition Match Player Squad],
      'Player' => %w[Contract Injury Loan Transfer],
      'Match' => %w[Booking Cap Goal Substitution],
      'Competition' => %w[Stage],
      'Stage' => %w[Fixture TableRow]
    }.each do |parent_model, models|
      models.each do |model|
        add_mutation = Class.new(BaseMutation) do
          argument "#{parent_model.underscore}_id".to_sym,
                   GraphQL::Types::ID,
                   required: true
          argument :attributes,
                   Types::Inputs.const_get("#{model}Attributes"),
                   required: true

          field model.underscore.to_sym,
                Types::Myfifa.const_get("#{model}Type"),
                null: true
          field :errors, Types::ValidationErrorsType, null: true

          define_method :resolve do |**args|
            current_ability = Ability.new(context[:current_user])
            parent_id = args["#{parent_model.underscore}_id".to_sym]
            parent_record = parent_model
                            .constantize
                            .accessible_by(current_ability)
                            .find(parent_id)

            record = parent_record.public_send(model.underscore.pluralize).new
            record.attributes = args[:attributes].to_h

            if record.save
              { model.underscore.to_sym => record }
            else
              { errors: record.errors }
            end
          end
        end

        const_set("Add#{model}", add_mutation)
      end
    end
  end
end
