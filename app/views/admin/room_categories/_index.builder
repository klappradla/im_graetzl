context.instance_eval do
  selectable_column
  id_column
  column :position
  column :name
  column :created_at
  actions
end
