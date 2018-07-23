class CreateGroupCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :group_categories do |t|
      t.string :title
      t.references :group, foreign_key: true, index: true, on_delete: :cascade
      
      t.timestamps
    end
    
    add_reference :discussions, :group_category, foreign_key: { on_delete: :nullify }, index: true
    
    create_table :group_default_categories do |t|
      t.references :group, foreign_key: true, index: true, on_delete: :cascade
      t.references :group_category, foreign_key: true, index: true, on_delete: :cascade
    end
  end
end
