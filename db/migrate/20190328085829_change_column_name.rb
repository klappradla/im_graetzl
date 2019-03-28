class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :groups, :WelcomeMessage, :welcome_message
  end
end
