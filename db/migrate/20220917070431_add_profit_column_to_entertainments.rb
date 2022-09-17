class AddProfitColumnToEntertainments < ActiveRecord::Migration[7.0]
  def change
    add_column :entertainments, :profit, :integer
  end
end
