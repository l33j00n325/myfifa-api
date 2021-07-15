# frozen_string_literal: true

module GraphQL
  module AttributesHelpers
    def graphql_attributes_for(type, options = {})
      attributes_for(type, options)
        .transform_keys { |key| key.to_s.camelize(:lower) }
        .transform_values do |value|
          if value.is_a? Date
            value.to_s
          else
            value
          end
        end
    end
  end
end

RSpec::GraphQLResponse.configure do |config|
  config.graphql_schema = MyfifaApiSchema
end

RSpec.configure do |config|
  config.include GraphQL::AttributesHelpers, type: :graphql
end
