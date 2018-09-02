class AddPrivateToMeetings < ActiveRecord::Migration[5.0]
  def change
    add_column :meetings, :private, :boolean, default: false
  end
end
