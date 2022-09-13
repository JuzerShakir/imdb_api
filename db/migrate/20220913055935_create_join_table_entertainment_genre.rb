class CreateJoinTableEntertainmentGenre < ActiveRecord::Migration[7.0]
  def change
    create_join_table :entertainments, :genres
  end
end
