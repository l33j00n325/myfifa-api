# frozen_string_literal: true

module Statistics
  class CompetitionCompiler
    attr_accessor :team, :competition, :season

    def initialize(team:, competition: nil, season: nil)
      @team = team
      @competition = competition
      @season = season
    end

    def results
      matches_by_competition_and_season.map do |(competition, season), matches|
        {
          competition: competition,
          season: season,
          wins: 0,
          draws: 0,
          losses: 0,
          goals_for: 0,
          goals_against: 0
        }.tap do |data|
          matches.each do |match|
            next unless match.team_played?

            data[match.team_result.pluralize.to_sym] += 1
            data[:goals_for] += match.team_score
            data[:goals_against] += match.other_score
          end
        end
      end
    end

    private

      def matches_by_competition_and_season
        @team.matches.where({
          competition: competition,
          season: season
        }.compact).group_by { |match| [match.competition, match.season] }
      end
  end
end
