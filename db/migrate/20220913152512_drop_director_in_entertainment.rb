class DropDirectorInEntertainment < ActiveRecord::Migration[7.0]
  def change
    remove_column :entertainments, :director
  end
end
