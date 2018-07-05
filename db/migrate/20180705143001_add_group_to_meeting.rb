class AddGroupToMeeting < ActiveRecord::Migration[5.0]
  def change
    add_reference :meetings, :group, foreign_key: { on_delete: :nullify }, index: true
  end
end
