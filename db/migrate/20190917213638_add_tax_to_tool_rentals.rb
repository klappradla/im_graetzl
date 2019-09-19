class AddTaxToToolRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :tool_rentals, :tax, :decimal, precision: 10, scale: 2, default: 0
  end
end
