class AddForeignKeyToGoingTos < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :going_tos, :meeting_additional_dates, column: :meeting_additional_date_id, on_delete: :nullify
  end
end
