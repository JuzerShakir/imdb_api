class CreateEntertainments < ActiveRecord::Migration[7.0]
  def change
    create_table :entertainments do |t|
      t.string :title
      t.string :director
      t.float :ratings
      t.string :tagline
      t.string :story
      t.datetime :release_date
      t.string :popularity
      t.string :type
      t.string :identifier, index:{ unique: true }, null: false
      t.integer :runtime
      t.string :revenue
      t.string :budget
      t.string :url

      t.timestamps
    end
  end
end
