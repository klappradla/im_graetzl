class ChangeDefaultvalueForGoingTo < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:going_tos, :payment_status, from: 0, to: nil)
  end
end
