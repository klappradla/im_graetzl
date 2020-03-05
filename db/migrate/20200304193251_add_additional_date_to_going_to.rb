class AddAdditionalDateToGoingTo < ActiveRecord::Migration[5.2]
  def change
    add_column :going_tos, :going_to_date, :date
    add_column :going_tos, :going_to_time, :time
  end
end
