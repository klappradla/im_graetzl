context.instance_eval do
  selectable_column
  id_column
  column :slogan
  column :user
  column(:status){|r| status_tag(r.status)}
  column(:comment_count) {|r| r.comments.size }
  column :created_at
  column :last_activated_at
  actions
end
