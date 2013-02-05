class SearchLevelUserLevel < ActiveRecord::Migration
  def up
    add_column :users, :level, :integer
  end

  def down
    remove_column :users, :level
  end
end
