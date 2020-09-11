class MoveVatIdToAddress < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :vat_id, :string
    add_column :billing_addresses, :vat_id, :string
  end
end
