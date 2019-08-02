context.instance_eval do
  selectable_column
  id_column
  column :title
  column :price_per_day
  column :user
  column(:comment_count) {|r| r.comments.size }
  column :graetzl
  column :created_at
  actions
end
