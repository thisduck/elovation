class AddResultRuleToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :result_rule, :string, default: 'any_user'
  end
end
