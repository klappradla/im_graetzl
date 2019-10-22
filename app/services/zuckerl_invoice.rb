class ZuckerlInvoice

  def invoice(zuckerl)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_billing_address(pdf, zuckerl)
    add_company_info(pdf)
    add_zuckerl_info(pdf, zuckerl)
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.image "#{Rails.root}/app/assets/images/invoice-logo.png", width: 205, position: :right
    pdf.move_down 10
  end

  def add_billing_address(pdf, zuckerl)
    if zuckerl.location.billing_address.present?
      pdf.text "Rechnungsempfänger", style: :bold
      pdf.text zuckerl.location.billing_address.full_name
      pdf.text zuckerl.location.billing_address.company
      pdf.text zuckerl.location.billing_address.street
      pdf.text "#{zuckerl.location.billing_address.zip} #{zuckerl.location.billing_address.city}"
    end
    pdf.move_down 40
  end

  def add_company_info(pdf)
    pdf.text "Rechnungssteller", style: :bold
    pdf.text "imGrätzl.at wird betrieben von:"
    pdf.text "morgenjungs GmbH"
    pdf.text "Ausstellungsstrasse 9/9"
    pdf.text "A-1020 Wien"
    pdf.text "UID: ATU 69461502"
    pdf.text "wir@imgraetzl.at"
    pdf.move_down 40
  end

  def add_zuckerl_info(pdf, zuckerl)
    pdf.text "Rechnungsnummer: #{zuckerl.invoice_number}"
    pdf.text "Rechnungsdatum: #{zuckerl.created_at.to_date}"
    pdf.move_down 20
    pdf.text "Rechnung", size: 20, style: :bold
    pdf.move_down 20

    table_data = []
    table_data << ["ID", "Grätzlzuckerl / Location", "Laufzeit", "Sichtbarkeit", "Preis"]
    table_data << [zuckerl.id, zuckerl.location.name, (I18n.localize zuckerl.created_at.end_of_month+1.day, format: '%B %Y'), zuckerl.visibility, zuckerl.basic_price_with_currency]
    table_data << [nil, nil, nil, "(20% MwSt.)", zuckerl.tax_with_currency]
    table_data << [nil, nil, nil, "Gesamt", zuckerl.total_price_with_currency]

    pdf.table(table_data, width: pdf.bounds.width, column_widths: {5 => 60}) do
      cells.borders = []
      cells.border_color = "DDDDDD"
      row(0).background_color = "EEEEEE"
      row(0).borders = [:top, :bottom]
      row(1).borders = [:bottom]
      row(-1).borders = [:top]
    end
  end

  def format_price(amount)
    "#{'%.2f' % amount} €"
  end

end
