class RoomRentalInvoice

  def generate_for_renter(room_rental)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_renter_info(pdf, room_rental)
    add_renter_price_info(pdf, room_rental)
    add_company_info(pdf)
    pdf.render
  end

  def generate_for_owner(room_rental)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_owner_info(pdf, room_rental.room_offer)
    add_owner_price_info(pdf, room_rental)
    add_company_info(pdf)
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.image "#{Rails.root}/app/assets/images/invoice-logo.png", width: 205, position: :right
  end

  def add_renter_info(pdf, room_rental)
    pdf.text room_rental.renter_company if room_rental.renter_company.present?
    pdf.text room_rental.renter_name
    pdf.text room_rental.renter_address
    pdf.text "#{room_rental.renter_zip} #{room_rental.renter_city}"
    pdf.move_down 50
  end

  def add_renter_price_info(pdf, room_rental)
    pdf.text "Rechnungsnummer: #{room_rental.invoice_number}"
    pdf.text "Datum: #{room_rental.created_at.to_date}"
    pdf.move_down 10
    pdf.text "Rechnung", size: 20, style: :bold
    pdf.move_down 10

    table_data = []
    table_data << ["ID", "Raumteiler", "Miete", "Ende", "Vermieter", "Preis"]
    table_data << [room_rental.id, room_rental.room_offer.slogan, room_rental.rental_period, room_rental.owner.full_name, format_price(room_rental.basic_price)]
    table_data << [nil, nil, nil, nil, "Rabatt", format_price(-room_rental.discount)] if room_rental.discount?
    table_data << [nil, nil, nil, nil, "(20% MwSt.)", format_price(room_rental.tax)]
    table_data << [nil, nil, nil, nil, "Gesamt", format_price(room_rental.total_price)]

    pdf.table(table_data, width: pdf.bounds.width, column_widths: {5 => 60}) do
      cells.borders = []
      cells.border_color = "DDDDDD"
      row(0).background_color = "EEEEEE"
      row(0).borders = [:top, :bottom]
      row(1).borders = [:bottom]
      row(-1).borders = [:top]
    end
    pdf.move_down 50
  end

  def add_owner_info(pdf, room_offer)
    pdf.text room_offer.slogan
    pdf.text room_offer.address.street
    pdf.text "#{room_offer.address.zip} #{room_offer.address.city}"
    pdf.move_down 50
  end

  def add_owner_price_info(pdf, room_rental)
    pdf.text "Rechnungsnummer: #{room_rental.invoice_number}"
    pdf.text "Datum: #{room_rental.created_at.to_date}"
    pdf.move_down 10
    pdf.text "Gutschrift", size: 20, style: :bold
    pdf.move_down 10

    table_data = []
    table_data << ["ID", "Raumteiler", "Miete", "Mieter", "Preis"]
    table_data << [room_rental.id, room_rental.room_offer.slogan, room_rental.rental_period, room_rental.renter_name, format_price(room_rental.basic_price)]
    table_data << [nil, nil, nil, nil, "Rabatt", format_price(-room_rental.discount)] if room_rental.discount?
    table_data << [nil, nil, nil, nil, "(20% MwSt.)", format_price(room_rental.tax)]
    table_data << [nil, nil, nil, nil, "Servicegebühr Gesamt (Inkl. MwSt)", format_price(-room_rental.service_fee)]
    table_data << [nil, nil, nil, nil, "Auszahlungsbetrag", format_price(room_rental.owner_payout_amount)]

    pdf.table(table_data, width: pdf.bounds.width, column_widths: {5 => 60}) do
      cells.borders = []
      cells.border_color = "DDDDDD"
      row(0).background_color = "EEEEEE"
      row(0).borders = [:top, :bottom]
      row(1).borders = [:bottom]
      row(-1).borders = [:top]
    end
    pdf.move_down 50
  end

  def add_company_info(pdf)
    pdf.text "imGrätzl.at wird betrieben von:"
    pdf.text "morgenjungs GmbH"
    pdf.text "Ausstellungsstrasse 9/9"
    pdf.text "A-1020 Wien"
    pdf.text "wir@imgraetzl.at"
  end

  def format_price(amount)
    "#{'%.2f' % amount} €"
  end

end
