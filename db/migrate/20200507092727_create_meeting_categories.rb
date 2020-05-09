class CreateMeetingCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_categories do |t|
      t.string :title
      t.string :icon

      # used for eputoepu campaign
      t.date :starts_at_date
      t.date :ends_at_date

      t.references :meeting, index: true, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
