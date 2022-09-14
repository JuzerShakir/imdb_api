class AddNullConstraintToNameAttributes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :directors, :name, true
    change_column_null :genres, :name, true
    change_column_null :stars, :name, true
    change_column_null :producers, :name, true
  end
end
