class DiscussionSetDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :discussions, :closed, :boolean, default: false
    change_column :discussions, :sticky, :boolean, default: false
  end
end
