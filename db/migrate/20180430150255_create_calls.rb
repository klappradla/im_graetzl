class CreateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :calls do |t|
      t.string :title
      t.text :description
      t.references :room_offer, foreign_key: { on_delete: :cascade }, index: true
      t.references :group, foreign_key: { on_delete: :nullify }, index: true
      t.date :starts_at
      t.date :ends_at
      t.timestamps
    end

    add_column :room_offers, :status, :integer, default: 0

    create_table :call_fields do |t|
      t.references :call, foreign_key: { on_delete: :cascade }, index: true
      t.string :label
      t.timestamps
    end

    create_table :call_submissions do |t|
      t.references :user, foreign_key: { on_delete: :nullify }, index: true
      t.references :call, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end

    create_table :call_submission_fields do |t|
      t.references :call_submission, foreign_key: { on_delete: :cascade }, index: true
      t.references :call_field, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end
  end
end
