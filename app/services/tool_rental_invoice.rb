class ToolRentalInvoice

  def generate_for_renter(tool_rental)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_renter_info(pdf, tool_rental)
    add_renter_price_info(pdf, tool_rental)
    add_company_info(pdf)
    pdf.render
  end

  def generate_for_owner(tool_rental)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_owner_info(pdf, tool_rental.tool_offer)
    add_owner_price_info(pdf, tool_rental)
    add_company_info(pdf)
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.image "#{Rails.root}/app/assets/images/invoice-logo.png", width: 205, position: :right
  end

  def add_renter_info(pdf, tool_rental)
    pdf.text tool_rental.renter_company if tool_rental.renter_company.present?
    pdf.text tool_rental.renter_name
    pdf.text tool_rental.renter_address
    pdf.text "#{tool_rental.renter_zip} #{tool_rental.renter_city}"
    pdf.move_down 50
  end

  def add_renter_price_info(pdf, tool_rental)
    pdf.text "Rechnungsnummer: #{tool_rental.invoice_number}"
    pdf.text "Datum: #{tool_rental.created_at.to_date}"
    pdf.move_down 10
    pdf.text "Rechnung", size: 20, style: :bold
    pdf.move_down 10

    table_data = []
    table_data << ["ID", "Toolteiler", "Start", "Ende", "Vermieter", "Preis"]
    table_data << [tool_rental.id, tool_rental.tool_offer.title, tool_rental.rent_from, tool_rental.rent_to, tool_rental.owner.full_name, format_price(tool_rental.basic_price)]
    table_data << [nil, nil, nil, nil, "Rabatt", format_price(-tool_rental.discount)] if tool_rental.discount?
    table_data << [nil, nil, nil, nil, "Servicegebühr", format_price(tool_rental.service_fee)]
    table_data << [nil, nil, nil, nil, "(20% MwSt.)", format_price(tool_rental.tax)]
    table_data << [nil, nil, nil, nil, "Servicegebühr Gesamt (Inkl. Versicherung und MwSt)", format_price(tool_rental.total_fee)]
    table_data << [nil, nil, nil, nil, "Gesamt", format_price(tool_rental.total_price)]

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

  def add_owner_info(pdf, tool_offer)
    pdf.text tool_offer.full_name
    pdf.text tool_offer.address.street
    pdf.text "#{tool_offer.address.zip} #{tool_offer.address.city}"
    pdf.move_down 50
  end

  def add_owner_price_info(pdf, tool_rental)
    pdf.text "Rechnungsnummer: #{tool_rental.invoice_number}"
    pdf.text "Datum: #{tool_rental.created_at.to_date}"
    pdf.move_down 10
    pdf.text "Gutschrift", size: 20, style: :bold
    pdf.move_down 10

    table_data = []
    table_data << ["ID", "Toolteiler", "Start", "Ende", "Mieter", "Preis"]
    table_data << [tool_rental.id, tool_rental.tool_offer.title, tool_rental.rent_from, tool_rental.rent_to, tool_rental.renter_name, format_price(tool_rental.basic_price)]
    table_data << [nil, nil, nil, nil, "Rabatt", format_price(-tool_rental.discount)] if tool_rental.discount?
    table_data << [nil, nil, nil, nil, "Servicegebühr", format_price(-tool_rental.service_fee)]
    table_data << [nil, nil, nil, nil, "(20% MwSt.)", format_price(-tool_rental.tax)]
    table_data << [nil, nil, nil, nil, "Servicegebühr Gesamt (Inkl. MwSt)", format_price(-tool_rental.service_fee - tool_rental.tax)]
    table_data << [nil, nil, nil, nil, "Auszahlungsbetrag", format_price(tool_rental.owner_payout_amount)]

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
