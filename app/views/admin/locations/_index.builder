context.instance_eval do
  selectable_column
  id_column
  column :name
  column(:state){ |l| status_tag(l.state) }
  column :location_category
  column :graetzl
  column :users do |location|
    safe_join(location.users.map { |user| link_to(user.username, admin_user_path(user)) }, ', ')
  end
  actions
end
