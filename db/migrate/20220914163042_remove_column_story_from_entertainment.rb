class RemoveColumnStoryFromEntertainment < ActiveRecord::Migration[7.0]
  def up
    remove_column :entertainments, :story
  end

  def down
    add_column :entertainments, :story, :string
  end
end
