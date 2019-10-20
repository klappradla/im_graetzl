class AddAllDistrictsToZuckerls < ActiveRecord::Migration[5.2]
  def change
    add_column :zuckerls, :all_districts, :boolean, default: false
  end
end
