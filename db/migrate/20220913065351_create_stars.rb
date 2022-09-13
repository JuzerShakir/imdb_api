class CreateStars < ActiveRecord::Migration[7.0]
  def change
    create_table :stars do |t|
      t.string :name

      t.timestamps
    end
    add_index :stars, :name, unique: true
  end
end
