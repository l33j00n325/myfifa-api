# frozen_string_literal: true

require 'rails_helper'

describe Mutations::UpdateMutations do
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
    describe described_class.const_get("Update#{model}"), type: :graphql do
      subject { described_class }

      let(:record) { create model.underscore.to_sym }

      it { is_expected.to accept_argument(:id).of_type('ID!') }
      it { is_expected.to accept_argument(:attributes).of_type("#{model}Attributes!") }
      it { is_expected.to have_a_field(model.underscore.to_sym).returning(model) }
      it { is_expected.to have_a_field(:errors).returning('ValidationErrors') }

      graphql_operation "
        mutation update#{model}($id: ID!, $attributes: #{model}Attributes!) {
          update#{model}(id: $id, attributes: $attributes) {
            #{model.camelize(:lower)} { id }
            errors { fullMessages }
          }
        }
      "

      graphql_variables do
        {
          id: record.id,
          attributes:
            case model
            when 'Cap'
              {
                playerId: record.player_id,
                pos: Cap::POSITIONS[Cap::POSITIONS.index(record.pos) - 1]
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
              graphql_attributes_for(:squad).merge(
                squadPlayersAttributes: record.squad_players.map do |squad_player|
                  {
                    id: squad_player.id,
                    playerId: squad_player.player_id,
                    pos: Cap::POSITIONS[Cap::POSITIONS.index(squad_player.pos) - 1]
                  }
                end
              )
            when 'Substitution'
              graphql_attributes_for(:substitution).merge(
                playerId: record.player_id,
                replacementId: record.replacement_id
              )
            else
              graphql_attributes_for(model.underscore)
            end
        }
      end

      graphql_context do
        { current_user: record.team.user }
      end

      it "updates the #{model}" do
        old_attributes = record.attributes
        execute_graphql
        expect(record.reload.attributes).not_to be == old_attributes
      end

      it "returns the update #{model}" do
        expect(response_data.dig("update#{model}", model.camelize(:lower), 'id'))
          .to be == record.id.to_s
      end
    end
  end
end
