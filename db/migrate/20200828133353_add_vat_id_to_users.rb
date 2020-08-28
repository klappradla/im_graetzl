class AddVatIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :vat_id, :string
  end
end
