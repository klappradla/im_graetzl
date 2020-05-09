context.instance_eval do
  selectable_column
  id_column
  column :title
  column :starts_at_date
  column :ends_at_date
  actions
end
