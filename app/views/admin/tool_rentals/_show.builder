context.instance_eval do
  panel 'Tool Offer' do
    attributes_table_for tool_rental.tool_offer do
      row :title
      row :user
      row :iban
    end
  end

  panel 'Rent Request' do
    attributes_table_for tool_rental do
      row :id
      row :user
      row :rent_from
      row :rent_to
      row :renter_company
      row :renter_name
      row :renter_address
      row :renter_zip
      row :renter_city
      row :rental_status
      row :created_at
    end
  end

  panel 'Payment' do
    attributes_table_for tool_rental do
      row :basic_price
      row :discount
      row :service_fee
      row :insurance_fee
      row :tax
      row :total_price
      row :payment_method
      row :payment_status
    end
  end

  panel 'Rating' do
    attributes_table_for tool_rental do
      row :owner_rating
      row :renter_rating
    end
  end

end
