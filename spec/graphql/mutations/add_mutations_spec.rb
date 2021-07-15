# frozen_string_literal: true

require 'rails_helper'

describe Mutations::AddMutations do
  {
    # 'Team' => ['Player']
    'Team' => %w[Competition Match Player Squad],
    'Player' => %w[Contract Injury Loan Transfer],
    'Match' => %w[Booking Cap Goal Substitution],
    'Competition' => %w[Stage],
    'Stage' => %w[Fixture TableRow]
  }.each do |parent_model, models|
    parent = parent_model.camelize(:lower)

    models.each do |model|
      describe described_class.const_get("Add#{model}"), type: :graphql do
        subject { described_class }

        let(:parent_record) { create parent_model.underscore.to_sym }

        it { is_expected.to accept_argument("#{parent_model.underscore}_id".to_sym).of_type('ID!') }
        it { is_expected.to accept_argument(:attributes).of_type("#{model}Attributes!") }
        it { is_expected.to have_a_field(model.underscore.to_sym).returning(model) }
        it { is_expected.to have_a_field(:errors).returning('ValidationErrors') }

        graphql_operation "
          mutation add#{model}($#{parent}Id: ID!, $attributes: #{model}Attributes!) {
            add#{model}(#{parent}Id: $#{parent}Id, attributes: $attributes) {
              #{model.camelize(:lower)} { id }
              errors { fullMessages }
            }
          }
        "

        graphql_variables do
          {
            "#{parent}Id" => parent_record.id,
            attributes:
              case model
              when 'Booking'
                graphql_attributes_for(:booking).merge(
                  playerId: create(:player, team: parent_record.team).id
                )
              when 'Cap'
                {
                  playerId: create(:player, team: parent_record.team).id,
                  pos: Cap::POSITIONS.sample
                }
              when 'Fixture'
                graphql_attributes_for(:fixture).merge(
                  legsAttributes: [graphql_attributes_for(:fixture_leg)]
                )
              when 'Player'
                graphql_attributes_for(:player).except('birthYear').merge(
                  age: Faker::Number.between(from: 18, to: 30).to_i
                )
              when 'Squad'
                {
                  name: Faker::Team.name,
                  squadPlayersAttributes: (0...11).map do |i|
                    {
                      playerId: create(:player, team: parent_record).id,
                      pos: Cap::POSITIONS[i]
                    }
                  end
                }
              when 'Substitution'

                graphql_attributes_for(:substitution).merge(
                  playerId: create(:player, team: parent_record.team).id,
                  replacementId: create(:player, team: parent_record.team).id
                )
              else
                graphql_attributes_for(model.underscore)
              end
          }
        end

        graphql_context do
          { current_user: parent_record.team.user }
        end

        it "creates a #{model} for the #{parent_model}" do
          record_id = response_data.dig("add#{model}", model.camelize(:lower), 'id')
          expect(parent_record.reload.public_send(model.underscore.pluralize).pluck(:id))
            .to include record_id.to_i
        end

        it "returns the created #{model}" do
          expect(response_data.dig("add#{model}", model.camelize(:lower), 'id'))
            .to be_present
        end
      end
    end
  end
end
