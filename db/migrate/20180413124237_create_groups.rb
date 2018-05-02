class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :title
      t.text :description
      t.references :admin, foreign_key: { to_table: :users }, index: true
      t.references :room_offer, foreign_key: true, index: true
      t.boolean :private

      t.timestamps
    end
    
    create_table :group_users do |t|
      t.references :group, index: true
      t.references :user, index: true
      
      t.timestamps
    end
    
    create_table :discussions do |t|
      t.string :title
      t.boolean :closed
      t.boolean :sticky
      t.references :group, foreign_key: true, index: true, on_delete: :cascade

      t.timestamps
    end
    
    create_table :discussion_posts do |t|
      t.text :content
      t.references :discussion, foreign_key: true, index: true, on_delete: :cascade
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
