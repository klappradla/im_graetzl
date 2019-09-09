class AddStripeSourcetoToolRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :tool_rentals, :stripe_source_id, :string
    add_column :tool_rentals, :stripe_charge_id, :string
  end
end
