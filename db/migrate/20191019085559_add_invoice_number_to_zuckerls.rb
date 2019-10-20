class AddInvoiceNumberToZuckerls < ActiveRecord::Migration[5.2]
  def change
    add_column :zuckerls, :invoice_number, :string
  end
end
