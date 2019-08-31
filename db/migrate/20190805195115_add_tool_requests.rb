class AddToolRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :tool_rentals do |t|
      t.references :tool_offer, foreign_key: { on_delete: :nullify }, index: true
      t.references :user, foreign_key: { on_delete: :nullify }, index: true
      t.date :rent_from
      t.date :rent_to
      t.string :renter_company
      t.string :renter_name
      t.string :renter_address
      t.string :renter_zip
      t.string :renter_city
      t.integer :status, default: 0
      t.string :stripe_customer_id
      t.integer :owner_rating
      t.integer :renter_rating
      t.timestamps
    end
  end
end
