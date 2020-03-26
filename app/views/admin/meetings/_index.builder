context.instance_eval do
  selectable_column
  id_column
  column :name
  column(:state){ |m| status_tag(m.state) }
  column :graetzl
  column :user
  column 'API', :approved_for_api
  column :online_meeting
  actions
end
