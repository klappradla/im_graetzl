class AddCoverToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :cover_photo_id, :string
    add_column :groups, :cover_photo_type, :string
  end
end
