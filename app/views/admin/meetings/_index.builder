context.instance_eval do
  selectable_column
  id_column
  column :name
  #column(:state){ |m| status_tag(m.state) }
  column :graetzl
  column :user
  #column 'Category',:meeting_category
  column(:event_categories) { |m| m.event_categories.map(&:title).join(", ") }
  #column 'Online Event', :online_meeting
  column 'SFS', :platform_meeting
  column 'API', :approved_for_api
  actions
end
