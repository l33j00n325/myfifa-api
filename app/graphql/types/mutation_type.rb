# frozen_string_literal: true

module Types
  class MutationType < BaseObject
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
    ].each do |klass|
      if klass == 'Team'
        field :add_team, mutation: Mutations::AddTeam
      else
        field "add_#{klass.underscore}".to_sym,
              mutation: Mutations::AddMutations.const_get("Add#{klass}")
      end
      field "update_#{klass.underscore}".to_sym,
            mutation: Mutations::UpdateMutations.const_get("Update#{klass}")
      field "remove_#{klass.underscore}".to_sym,
            mutation: Mutations::RemoveMutations.const_get("Remove#{klass}")
    end

    field :update_user, mutation: Mutations::UpdateMutations::UpdateUser
  end
end
