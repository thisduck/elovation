class RenameGameToLeague < ActiveRecord::Migration
  def change
    rename_table :games, :leagues
  end
end
