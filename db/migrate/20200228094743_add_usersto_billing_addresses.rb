class AddUserstoBillingAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :billing_addresses, :user_id, :integer
    add_index :billing_addresses, :user_id
    add_foreign_key :billing_addresses, :users, on_delete: :nullify
  end
end
