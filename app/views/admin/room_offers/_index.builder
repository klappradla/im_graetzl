context.instance_eval do
  selectable_column
  id_column
  column :slogan
  column :user
  column(:Kurzzeitmiete) {|r| r.rental_enabled }
  column(:comment_count) {|r| r.comments.size }
  column :created_at
  column :last_activated_at
  #column :wants_collaboration
  #column(:room_categories) { |r| r.room_categories.map(&:name).join(", ") }
  column :graetzl
  actions
end
