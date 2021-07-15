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
    ].each do |model|
      if model == 'Team'
        field :add_team, mutation: Mutations::AddTeam
      else
        field "add_#{model.underscore}".to_sym,
              mutation: Mutations::AddMutations.const_get("Add#{model}")
      end
      field "update_#{model.underscore}".to_sym,
            mutation: Mutations::UpdateMutations.const_get("Update#{model}")
      field "remove_#{model.underscore}".to_sym,
            mutation: Mutations::RemoveMutations.const_get("Remove#{model}")
    end

    field :release_player, mutation: Mutations::ReleasePlayer
    field :retire_player, mutation: Mutations::RetirePlayer
    field :apply_squad_to_match, mutation: Mutations::ApplySquadToMatch
    field :store_match_lineup_to_squad,
          mutation: Mutations::StoreMatchLineupToSquad
    field :remove_penalty_shootout,
          mutation: Mutations::RemoveMutations::RemovePenaltyShootout
  end
end
