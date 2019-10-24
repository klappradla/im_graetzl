class AddLinkToZuckerls < ActiveRecord::Migration[5.2]
  def change
    add_column :zuckerls, :link, :string
  end
end
