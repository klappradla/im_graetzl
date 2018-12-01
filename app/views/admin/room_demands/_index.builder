context.instance_eval do
  selectable_column
  id_column
  column :slogan
  column :first_name
  column :last_name
  column :email
  column(:comment_count) {|r| r.comments.size }
  column :created_at
  actions
end
