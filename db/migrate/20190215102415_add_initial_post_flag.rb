class AddInitialPostFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :discussion_posts, :initial_post, :boolean, default: false
  end
end
