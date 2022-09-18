class ChangeLimitOfRevenueBudgetProfit < ActiveRecord::Migration[7.0]
  def up
    change_column :entertainments, :revenue, :integer, limit: 8
    change_column :entertainments, :budget, :integer, limit: 8
    change_column :entertainments, :profit, :integer, limit: 8
  end

  def down
    change_column :entertainments, :revenue, :integer, limit: 4
    change_column :entertainments, :budget, :integer, limit: 4
    change_column :entertainments, :profit, :integer, limit: 4
  end
end
