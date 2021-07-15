# frozen_string_literal: true

require 'rails_helper'

describe Mutations::RemoveMutations do
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
  ].each do |model|
    describe described_class.const_get("Remove#{model}"), type: :graphql do
      subject { described_class }

      let(:record) { create model.underscore.to_sym }

      it { is_expected.to accept_argument(:id).of_type('ID!') }
      it { is_expected.to have_a_field(model.underscore.to_sym).returning(model) }
      it { is_expected.to have_a_field(:errors).returning('ValidationErrors') }

      graphql_operation "
        mutation remove#{model}($id: ID!) {
          remove#{model}(id: $id) {
            #{model.camelize(:lower)} { id }
            errors { fullMessages }
          }
        }
      "

      graphql_variables do
        { id: record.id }
      end

      graphql_context do
        { current_user: record.team.user }
      end

      it "removes the #{model}" do
        execute_graphql
        expect { record.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns the removed #{model}" do
        expect(response_data.dig("remove#{model}", model.camelize(:lower), 'id'))
          .to be == record.id.to_s
      end
    end
  end
end
