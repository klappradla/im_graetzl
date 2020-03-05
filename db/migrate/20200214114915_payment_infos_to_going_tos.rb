class PaymentInfosToGoingTos < ActiveRecord::Migration[5.2]
  def change
    add_column :going_tos, :amount, :decimal, precision: 10, scale: 2
    add_column :going_tos, :payment_status, :integer, default: 0
    add_column :going_tos, :payment_method, :string
    add_column :going_tos, :stripe_payment_intent_id, :string
    add_column :going_tos, :stripe_invoice_id, :string
  end
end
