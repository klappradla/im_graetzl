class AddFieldsToRoomCalls < ActiveRecord::Migration[5.0]
  def change
    change_table :room_calls do |t|
      t.string :subtitle
      t.text :about_us
      t.text :about_partner
      t.date :opens_at
      t.string :slug
      t.integer :total_vacancies, default: 0
      t.belongs_to :graetzl, foreign_key: { on_delete: :nullify }, index: true
      t.belongs_to :district, foreign_key: { on_delete: :nullify }, index: true
      t.belongs_to :user, foreign_key: { on_delete: :nullify }, index: true
      t.belongs_to :location, foreign_key: { on_delete: :nullify }, index: true
      t.string :first_name
      t.string :last_name
      t.string :website
      t.string :email
      t.string :phone
      t.string :avatar_id
      t.string :avatar_content_type
      t.string :cover_photo_id
      t.string :cover_photo_content_type
    end
  end
end
