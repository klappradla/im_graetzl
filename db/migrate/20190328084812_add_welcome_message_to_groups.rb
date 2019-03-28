class AddWelcomeMessageToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :WelcomeMessage, :text
  end
end
