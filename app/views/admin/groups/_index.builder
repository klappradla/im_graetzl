context.instance_eval do
  selectable_column
  id_column
  column :title
  column :private
  column :featured
  column :hidden
  column :created_at
  column :admins do |l|
    safe_join(l.admins.map { |user| link_to(user.username, admin_user_path(user)) }, ', ')
  end
  actions
end
