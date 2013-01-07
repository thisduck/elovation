class ChangeGameIdColumnsToLeagueId < ActiveRecord::Migration
  def change
    rename_column :ratings, :game_id, :league_id
    rename_column :results, :game_id, :league_id
  end
end
