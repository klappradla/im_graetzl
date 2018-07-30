class ChangeMailSettingsDefault < ActiveRecord::Migration
  def up
    change_column_default :users, :immediate_mail_notifications, 2013
  end

  def down
    change_column_default :users, :immediate_mail_notifications, 2015
  end
end
