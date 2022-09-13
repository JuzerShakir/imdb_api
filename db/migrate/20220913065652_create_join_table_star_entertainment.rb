class CreateJoinTableStarEntertainment < ActiveRecord::Migration[7.0]
  def change
    create_join_table :stars, :entertainments
  end
end
