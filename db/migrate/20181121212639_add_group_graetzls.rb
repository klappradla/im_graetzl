class AddGroupGraetzls < ActiveRecord::Migration[5.0]
  def change
    create_table :group_graetzls do |t|
      t.references :group, foreign_key: { on_delete: :cascade }, index: true
      t.references :graetzl, foreign_key: { on_delete: :cascade }, index: true
    end

    add_index :group_categories, :title
  end
end
