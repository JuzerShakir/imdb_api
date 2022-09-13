class CreateProducers < ActiveRecord::Migration[7.0]
  def change
    create_table :producers do |t|
      t.string :name

      t.timestamps
    end
    add_index :producers, :name, unique: true
  end
end
