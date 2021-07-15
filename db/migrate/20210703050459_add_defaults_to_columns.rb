class AddDefaultsToColumns < ActiveRecord::Migration[6.1]
  def change
    change_column_default :caps, :start, 0
    change_column_default :caps, :stop, 90
    change_column_default :matches, :home_score, 0
    change_column_default :matches, :away_score, 0
  end
end
