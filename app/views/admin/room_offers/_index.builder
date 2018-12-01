context.instance_eval do
  selectable_column
  id_column
  column :slogan
  column :first_name
  column :last_name
  column :email
  column(:comment_count) {|r| r.comments.size }
  column :created_at
  #column :wants_collaboration
  #column(:room_categories) { |r| r.room_categories.map(&:name).join(", ") }
  column :graetzl
  actions
end
