class CreateJoinTableEntertainmentProducer < ActiveRecord::Migration[7.0]
  def change
    create_join_table :entertainments, :producers
  end
end
