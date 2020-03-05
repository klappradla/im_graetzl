context.instance_eval do
  selectable_column
  id_column
  column :meeting
  column :user
  column :amount
  column(:payment_status){|r| status_tag(r.payment_status)}
  column :payment_method
  column :created_at
  actions
end
