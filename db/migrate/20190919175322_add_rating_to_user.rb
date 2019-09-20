class AddRatingToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rating, :decimal, precision: 3, scale: 2
  end
end
