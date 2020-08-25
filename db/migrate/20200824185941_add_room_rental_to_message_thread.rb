class AddRoomRentalToMessageThread < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_message_threads, :room_rental, index: true, foreign_key: { on_delete: :nullify }
  end
end
