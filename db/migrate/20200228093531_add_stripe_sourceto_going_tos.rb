class AddStripeSourcetoGoingTos < ActiveRecord::Migration[5.2]
  def change
    add_column :going_tos, :stripe_source_id, :string
    add_column :going_tos, :stripe_charge_id, :string

    rename_column :going_tos, :stripe_invoice_id, :invoice_number

    add_index :going_tos, :stripe_payment_intent_id
  end
end
