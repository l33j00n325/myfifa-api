class CreateMatchEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :match_events do |t|
      t.belongs_to :match
      t.string :type
      t.integer :minute

      t.string :player_name
      t.belongs_to :player

      t.string :detail
      t.boolean :home, default: true

      t.timestamps
    end
  end
end
