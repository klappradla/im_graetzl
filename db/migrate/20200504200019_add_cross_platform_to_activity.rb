class AddCrossPlatformToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :cross_platform, :boolean, default: false
  end
end
