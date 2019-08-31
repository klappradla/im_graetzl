class AddUserMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_message_threads do |t|
      t.references :tool_rental, foreign_key: { on_delete: :nullify }, index: true
      t.datetime :last_message_at
      t.text :last_message, index: true
      t.timestamps
    end

    create_table :user_message_thread_members do |t|
      t.references :user_message_thread, foreign_key: { on_delete: :cascade }, index: true
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :user_messages do |t|
      t.references :user_message_thread, foreign_key: { on_delete: :cascade }, index: true
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.text :message
      t.timestamps
    end

  end
end
