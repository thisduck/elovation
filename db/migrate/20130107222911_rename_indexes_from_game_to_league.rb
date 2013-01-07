class RenameIndexesFromGameToLeague < ActiveRecord::Migration
  def change
    remove_index :ratings, :game_id
    add_index :ratings, :league_id

    remove_index :results, :game_id
    add_index :results, :league_id

  end
end
