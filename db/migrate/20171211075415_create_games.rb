class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.text :score
      t.integer :player_count
      t.integer :game_turn

      t.timestamps
    end
  end
end
