class AddNewParentsToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :room_demand_id, :integer, index: true
    add_index :groups, :room_demand_id
    add_foreign_key :groups, :room_demands, on_delete: :nullify

    add_column :groups, :location_id, :integer, index: true
    add_index :groups, :location_id
    add_foreign_key :groups, :locations, on_delete: :nullify
  end
end
