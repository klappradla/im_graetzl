class AddJoinQuestionsToGroup < ActiveRecord::Migration[5.0]
  def change
    create_table :group_join_questions do |t|
      t.references :group, index: true, foreign_key: { on_delete: :cascade }
      t.text :question
      t.timestamps
    end

    add_column :group_join_requests, :join_answers, :text, array: true, default: []
  end
end
