# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can_manage_team user
  end

  private

    def can_manage_team(user)
      can :manage, Team, user: user
      can_manage_player user
      can_manage_match user
      can_manage_squad user
      can_manage_competition user
    end

    def can_manage_player(user)
      can :manage, Player,   for_team?(user)
      can :manage, Injury,   for_player?(user)
      can :manage, Contract, for_player?(user)
      can :manage, Loan,     for_player?(user)
      can :manage, Transfer, for_player?(user)
    end

    def can_manage_match(user)
      can :manage, Match,           for_team?(user)
      can :manage, Cap,             for_match?(user)
      can :manage, Goal,            for_match?(user)
      can :manage, Booking,         for_match?(user)
      can :manage, Substitution,    for_match?(user)
      can :manage, PenaltyShootout, for_match?(user)
    end

    def can_manage_squad(user)
      can :manage, Squad, for_team?(user)
    end

    def can_manage_competition(user)
      can :manage, Competition, for_team?(user)
      can :manage, Stage,       for_competition?(user)
      can :manage, Fixture,     for_stage?(user)
      can :manage, TableRow,    for_stage?(user)
    end

    def for_team?(user)
      { team: { user_id: user.id } }
    end

    %w[player match competition].each do |model|
      define_method "for_#{model}?" do |user|
        { model.to_sym => for_team?(user) }
      end
    end

    def for_stage?(user)
      { stage: for_competition?(user) }
    end
end
