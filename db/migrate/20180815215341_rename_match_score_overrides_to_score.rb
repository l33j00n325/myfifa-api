class RenameMatchScoreOverridesToScore < ActiveRecord::Migration[5.2]
  def up
    rename_column :matches, :home_score_override, :home_score
    rename_column :matches, :away_score_override, :away_score

    @matches = Match.where(home_score: nil, away_score: nil).preload(:goals)
    Match.transaction do
      @matches.each do |match|
        match.update(
          home_score: match.goals.count { |goal| goal.home? ^ goal.own_goal? },
          away_score: match.goals.count { |goal| !goal.home? ^ goal.own_goal? }
        )
      end
    end
  end

  def down
    rename_column :matches, :home_score, :home_score_override
    rename_column :matches, :away_score, :away_score_override
  end
end
