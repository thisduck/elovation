class AddPosterIdToResult < ActiveRecord::Migration
  def change
    add_column :results, :poster_id, :integer
    add_index :results, :poster_id
  end
end
