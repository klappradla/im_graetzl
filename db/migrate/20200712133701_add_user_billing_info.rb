class AddUserBillingInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :billing_address, :text
  end
end
