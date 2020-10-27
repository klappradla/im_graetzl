context.instance_eval do
  selectable_column
  id_column
  column :position
  column :title
  column :created_at
  actions
end
