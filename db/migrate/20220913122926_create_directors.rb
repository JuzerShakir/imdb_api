class CreateDirectors < ActiveRecord::Migration[7.0]
  def change
    create_table :directors do |t|
      t.string :name

      t.timestamps
    end
    add_index :directors, :name, unique: true
  end
end
