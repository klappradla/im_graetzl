class GoingToInvoice

  def generate(going_to)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_billing_address(pdf, going_to)
    add_company_info(pdf)
    add_invoice_info(pdf, going_to)
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.image "#{Rails.root}/app/assets/images/invoice-logo.png", width: 205, position: :right
    pdf.move_down 10
  end

  def add_billing_address(pdf, going_to)
    if going_to.user.billing_address.present?
      pdf.text "Rechnungsempfänger", style: :bold
      pdf.text going_to.user.billing_address.full_name
      pdf.text going_to.user.billing_address.company
      pdf.text going_to.user.billing_address.street
      pdf.text "#{going_to.user.billing_address.zip} #{going_to.user.billing_address.city}"
    else
      pdf.text "Rechnungsempfänger", style: :bold
      pdf.text going_to.user.full_name
    end
    pdf.move_down 40
  end

  def add_company_info(pdf)
    pdf.text "Rechnungssteller", style: :bold
    pdf.text "imGrätzl.at wird betrieben von:"
    pdf.text "morgenjungs GmbH"
    pdf.text "Breitenfeldergasse 14/2A"
    pdf.text "A-1080 Wien"
    pdf.text "UID: ATU 69461502"
    pdf.text "wir@imgraetzl.at"
    pdf.move_down 40
  end

  def add_invoice_info(pdf, going_to)
    pdf.text "Rechnungsnummer: #{going_to.invoice_number}"
    pdf.text "Rechnungsdatum: #{going_to.created_at.to_date}"
    pdf.move_down 20
    pdf.text "Rechnung", size: 20, style: :bold
    pdf.move_down 20

    table_data = []
    table_data << ["ID", "Treffen", nil, "Preis"]
    table_data << [going_to.id, going_to.meeting.name, nil , format_price(going_to.amount_netto)]
    table_data << [nil, going_to.display_starts_at_date, "(20% MwSt.)", format_price(going_to.tax)]
    table_data << [nil, nil, "Gesamt", format_price(going_to.amount)]

    pdf.table(table_data, width: pdf.bounds.width, column_widths: {}) do
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
