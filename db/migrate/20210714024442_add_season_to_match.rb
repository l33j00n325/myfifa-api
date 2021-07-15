class AddSeasonToMatch < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :season, :integer

    reversible do |dir|
      dir.up do
        Match.transaction do
          Match.includes(:team).find_each do |match|
            match.update season: (match.played_on - match.team.started_on) / 365
          end
        end
      end
    end
  end
end
