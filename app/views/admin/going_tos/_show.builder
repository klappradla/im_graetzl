context.instance_eval do

  panel 'Ticket' do
    attributes_table_for going_to.meeting do
      row :name
    end
    attributes_table_for going_to do
      row :going_to_date
      row :id
      row :user
      row(:payment_status){|r| status_tag(r.payment_status)}
      row :payment_method
      row :amount
      row :created_at
    end
  end

  if going_to.invoice_number
    panel 'Rechnung' do
      attributes_table_for going_to do
        row(:invoice) { |r| link_to "PDF", r.invoice.presigned_url(:get) }
      end
    end
  end

end
