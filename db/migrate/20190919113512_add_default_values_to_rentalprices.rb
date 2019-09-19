class AddDefaultValuesToRentalprices < ActiveRecord::Migration[5.2]
  def change
    change_column :tool_rentals, :basic_price, :decimal, precision: 10, scale: 2, default: 0
    change_column :tool_rentals, :discount, :decimal, precision: 10, scale: 2, default: 0
    change_column :tool_rentals, :service_fee, :decimal, precision: 10, scale: 2, default: 0
    change_column :tool_rentals, :tax, :decimal, precision: 10, scale: 2, default: 0
    change_column :tool_rentals, :insurance_fee, :decimal, precision: 10, scale: 2, default: 0
    add_column :tool_rentals, :invoice_number, :string
  end
end
