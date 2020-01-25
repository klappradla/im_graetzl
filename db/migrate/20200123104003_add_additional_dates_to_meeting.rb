class AddAdditionalDatesToMeeting < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_additional_dates do |t|
      t.references :meeting, index: true, foreign_key: { on_delete: :cascade }
      t.date :starts_at_date
      t.time :starts_at_time
      t.time :ends_at_time
      t.timestamps
    end
  end
end
