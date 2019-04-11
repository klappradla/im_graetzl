context.instance_eval do
  selectable_column
  id_column
  column :name
  column(:state){ |m| status_tag(m.state) }
  column :graetzl
  column :user
  column :approved_for_api
  actions
end
