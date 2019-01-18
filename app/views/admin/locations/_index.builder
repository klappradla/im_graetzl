context.instance_eval do
  selectable_column
  id_column
  column :name
  column(:state){ |l| status_tag(l.state) }
  column :location_category
  column :graetzl
  column :user do |l|
    l.users.map do |user|
      link_to user.username, admin_user_path(user)
    end
  end
  actions
end
