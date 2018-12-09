class RenameGroupCoverPhotoType < ActiveRecord::Migration[5.0]
  def change
    rename_column :groups, :cover_photo_type, :cover_photo_content_type
  end
end
