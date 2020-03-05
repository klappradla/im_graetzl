class AddAmountToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :amount, :decimal, precision: 10, scale: 2
  end
end
