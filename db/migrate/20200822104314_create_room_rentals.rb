class CreateRoomRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :room_rentals do |t|
      t.references :room_offer, index: true, foreign_key: { on_delete: :nullify }
      t.references :user, index: true, foreign_key: { on_delete: :nullify }
      t.string :renter_company
      t.string :renter_name
      t.string :renter_address
      t.string :renter_zip
      t.string :renter_city
      t.integer :rental_status, default: 0
      t.integer :payment_status, default: 0
      t.string :payment_method
      t.decimal :hourly_price, precision: 10, scale: 2, default: 0
      t.decimal :basic_price, precision: 10, scale: 2, default: 0
      t.decimal :discount, precision: 10, scale: 2, default: 0
      t.decimal :service_fee, precision: 10, scale: 2, default: 0
      t.decimal :tax, precision: 10, scale: 2, default: 0
      t.string :stripe_source_id
      t.string :stripe_charge_id
      t.string :stripe_payment_intent_id, index: true
      t.string :invoice_number
      t.integer :owner_rating
      t.integer :renter_rating
      t.timestamps
    end

    create_table :room_rental_slots do |t|
      t.references :room_rental, index: true, foreign_key: { on_delete: :cascade }
      t.date :rent_date
      t.integer :hour_from, null: false
      t.integer :hour_to, null: false
      t.timestamps
    end

  end
end
