class AddOnlineMeetingDescriptionToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :online_meeting_description, :string
  end
end
