# frozen_string_literal: true

require 'rails_helper'

describe Statistics::CompetitionCompiler do
  let(:team) { create :team }
  let(:compiler) { described_class.new(team: team) }
  let(:results) { compiler.results }

  it 'requires a team' do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  describe 'result' do
    sample_competitions = %w[A B C].freeze

    let(:sample_set) do
      (0...Faker::Number.within(range: 5..10)).map do
        {
          home: Faker::Boolean.boolean,
          home_score: Faker::Number.within(range: 0..3),
          away_score: Faker::Number.within(range: 0..3),
          season: Faker::Number.within(range: 0..3),
          competition: sample_competitions.sample
        }
      end
    end

    before do
      sample_set.each do |set|
        create :match,
               team: team,
               home: set[:home] ? team.name : 'Home Team',
               away: set[:home] ? 'Away Team' : team.name,
               home_score: set[:home_score],
               away_score: set[:away_score],
               competition: set[:competition],
               played_on: team.started_on + set[:season].years
      end
    end

    it 'filters results by Competition if provided' do
      sample_competitions.each do |competition|
        compiler = described_class.new(team: team, competition: competition)
        num_in_set = sample_set.count { |set| set[:competition] == competition }
        num_in_results = compiler.results.pluck(:wins, :draws, :losses).sum(&:sum)
        expect(num_in_results).to be == num_in_set
      end
    end

    it 'filters results by Season if provided' do
      (0..3).each do |season|
        compiler = described_class.new(team: team, season: season)
        num_in_set = sample_set.count { |set| set[:season] == season }
        num_in_results = compiler.results.pluck(:wins, :draws, :losses).sum(&:sum)
        expect(num_in_results).to be == num_in_set
      end
    end

    it 'reports wins per season/competition set' do
      sample_competitions.each do |competition|
        (0..3).each do |season|
          num_in_set = sample_set.count do |set|
            if set[:competition] == competition && set[:season] == season
              if set[:home_score] > set[:away_score]
                set[:home]
              elsif set[:home_score] < set[:away_score]
                !set[:home]
              end
            else
              false
            end
          end
          num_in_results = results.find do |result|
            result[:competition] == competition && result[:season] == season
          end&.dig(:wins) || 0
          expect(num_in_results).to be == num_in_set
        end
      end
    end

    it 'reports draws per season/competition set' do
      sample_competitions.each do |competition|
        (0..3).each do |season|
          num_in_set = sample_set.count do |set|
            if set[:competition] == competition && set[:season] == season
              set[:home_score] == set[:away_score]
            else
              false
            end
          end
          num_in_results = results.find do |result|
            result[:competition] == competition && result[:season] == season
          end&.dig(:draws) || 0
          expect(num_in_results).to be == num_in_set
        end
      end
    end

    it 'reports losses per season/competition set' do
      sample_competitions.each do |competition|
        (0..3).each do |season|
          num_in_set = sample_set.count do |set|
            if set[:competition] == competition && set[:season] == season
              if set[:home_score] > set[:away_score]
                !set[:home]
              elsif set[:home_score] < set[:away_score]
                set[:home]
              end
            else
              false
            end
          end
          num_in_results = results.find do |result|
            result[:competition] == competition && result[:season] == season
          end&.dig(:losses) || 0
          expect(num_in_results).to be == num_in_set
        end
      end
    end

    it 'reports goals for per season/competition set' do
      sample_competitions.each do |competition|
        (0..3).each do |season|
          num_in_set = sample_set.sum do |set|
            if set[:competition] == competition && set[:season] == season
              set[:home] ? set[:home_score] : set[:away_score]
            else
              0
            end
          end
          num_in_results = results.find do |result|
            result[:competition] == competition && result[:season] == season
          end&.dig(:goals_for) || 0
          expect(num_in_results).to be == num_in_set
        end
      end
    end

    it 'reports goals against per season/competition set' do
      sample_competitions.each do |competition|
        (0..3).each do |season|
          num_in_set = sample_set.sum do |set|
            if set[:competition] == competition && set[:season] == season
              set[:home] ? set[:away_score] : set[:home_score]
            else
              0
            end
          end
          num_in_results = results.find do |result|
            result[:competition] == competition && result[:season] == season
          end&.dig(:goals_against) || 0
          expect(num_in_results).to be == num_in_set
        end
      end
    end
  end
end
