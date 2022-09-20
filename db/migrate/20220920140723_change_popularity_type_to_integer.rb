class ChangePopularityTypeToInteger < ActiveRecord::Migration[7.0]
  def up
      change_column :entertainments, :popularity, 'integer USING CAST(popularity AS integer)'
  end

  def down
    change_column :entertainments, :popularity, :string
  end
end
