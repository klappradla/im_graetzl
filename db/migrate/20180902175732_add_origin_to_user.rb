class AddOriginToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :origin, :string
  end
end
