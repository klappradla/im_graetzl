class AddHiddenToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :hidden, :boolean, default: false
  end
end
