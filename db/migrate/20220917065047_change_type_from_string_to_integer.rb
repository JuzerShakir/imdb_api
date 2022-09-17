class ChangeTypeFromStringToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column :entertainments, :revenue, 'integer USING CAST(revenue AS integer)'
    change_column :entertainments, :budget, 'integer USING CAST(budget AS integer)'
  end

  def down
    change_column :entertainments, :revenue, :string
    change_column :entertainments, :budget, :string
  end
end
