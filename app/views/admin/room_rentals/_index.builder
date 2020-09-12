context.instance_eval do
  selectable_column
  id_column
  column :owner
  column :renter
  column :rental_period
  column :total_price
  column :owner_payout_amount
  column(:rental_status){|r| status_tag(r.rental_status)}
  column :payment_status
  column :payment_method
  column :created_at
  actions
end
