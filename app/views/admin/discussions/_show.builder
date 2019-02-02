context.instance_eval do
  attributes_table do
    row :created_at
    row :title
    row :sticky
    row :group_id
    row :user_id
  end

  panel "Beiträge" do
    table_for discussion.discussion_posts do
      column :id
      column(:content){|p| truncate(p.content, length: 20)}
      column :user_id
      column :created_at
      column(''){|p| link_to 'Anzeigen', admin_discussion_post_path(p) }
    end
  end

end
