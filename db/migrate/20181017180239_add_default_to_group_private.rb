class AddDefaultToGroupPrivate < ActiveRecord::Migration[5.0]
  def change
    change_column :groups, :private, :boolean, default: false
  end
end
