context.instance_eval do
  panel 'Room Offer' do
    attributes_table_for room_rental.room_offer do
      row :slogan
      row :user
      row(:iban) { |r| r.user.iban }
    end
  end

  panel 'Rent Request' do
    attributes_table_for room_rental do
      row :id
      row :user
      row(:rental_status){|r| status_tag(r.rental_status)}
      row :rental_period
      row :renter_company
      row :renter_name
      row :renter_address
      row :renter_zip
      row :renter_city
      row :created_at
    end
  end

  panel 'Payment' do
    attributes_table_for room_rental do
      row :basic_price
      row :discount
      row :tax
      row :total_price
      row :basic_service_fee
      row :service_fee_tax
      row :service_fee
      row :owner_payout_amount
      row :payment_method
      row :payment_status
    end
  end

  if room_rental.approved?
    panel 'Invoices' do
      attributes_table_for room_rental do
        row(:owner_invoice) { |r| link_to "PDF", r.owner_invoice.presigned_url(:get) }
        row(:renter_invoice) { |r| link_to "PDF", r.renter_invoice.presigned_url(:get) }
      end
    end
  end

end
