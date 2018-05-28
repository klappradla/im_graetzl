class UpdateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :group_join_requests do |t|
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.references :group, foreign_key: { on_delete: :cascade }, index: true
      t.boolean :rejected, default: false
      t.timestamps
    end

    rename_table :calls, :room_calls
    remove_column :room_calls, :room_offer_id, :integer

    drop_table :call_submission_fields
    drop_table :call_submissions
    drop_table :call_fields

    create_table :room_call_fields do |t|
      t.references :room_call, foreign_key: { on_delete: :cascade }, index: true
      t.string :label
      t.timestamps
    end

    create_table :room_call_submissions do |t|
      t.references :user, foreign_key: { on_delete: :nullify }, index: true
      t.references :room_call, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end

    create_table :room_call_submission_fields do |t|
      t.references :room_call_submission, foreign_key: { on_delete: :cascade }, index: true
      t.references :room_call_field, foreign_key: { on_delete: :cascade }, index: true
      t.text :content
      t.timestamps
    end

  end
end
