class AddFeaturedToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :featured, :boolean, default: false
  end
end
