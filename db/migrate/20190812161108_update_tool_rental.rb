class UpdateToolRental < ActiveRecord::Migration[5.2]
  def change
    add_column :tool_rentals, :payment_method, :string
    add_column :tool_rentals, :basic_price, :decimal, precision: 10, scale: 2
    add_column :tool_rentals, :discount, :decimal, precision: 10, scale: 2
    add_column :tool_rentals, :service_fee, :decimal, precision: 10, scale: 2
    add_column :tool_rentals, :insurance_fee, :decimal, precision: 10, scale: 2

    rename_column :tool_rentals, :stripe_customer_id, :stripe_payment_intent_id
    rename_column :tool_rentals, :status, :rental_status
    add_column :tool_rentals, :payment_status, :integer, default: 0

    add_index :tool_rentals, :stripe_payment_intent_id
    add_index :users, :stripe_customer_id
  end
end
