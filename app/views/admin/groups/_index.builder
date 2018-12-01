context.instance_eval do
  selectable_column
  id_column
  column :title
  column :private
  column :created_at
  column :admins do |l|
    l.admins.map do |user|
      link_to user.username, admin_user_path(user)
    end
  end
  actions
end
