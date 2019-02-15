context.instance_eval do
  selectable_column
  id_column
  column :title
  column :mailchimp_id
  column :created_at
  actions
end
