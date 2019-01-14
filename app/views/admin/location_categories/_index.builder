context.instance_eval do
  selectable_column
  id_column
  column :name
  column(:context){|c| status_tag(c.context) }
  actions
end
