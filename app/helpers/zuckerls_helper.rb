module ZuckerlsHelper
  def zuckerl_state_for(zuckerl)
    case
    when zuckerl.pending?
      content_tag(:div, 'Warten auf Zahlungseingang', class: 'state') +
      content_tag(:div, 'Wir schicken dir eine E-Mail, sobald deine Zahlung bei uns eingelangt ist und dein Zuckerl freigeschalten wurde.', class: 'txt')
    when zuckerl.draft?
      content_tag(:div, 'Dein Grätzlzuckerl', class: 'state') +
      content_tag(:div, "Dein Zuckerl läuft im #{zuckerl_month_and_year zuckerl} mit der Sichtbarkeit: #{zuckerl.visibility}", class: 'txt')
    when zuckerl.paid?
      content_tag(:div, 'Deine Zahlung wurde erfolgreich geprüft!', class: 'state') +
      content_tag(:div, "Dein Zuckerl läuft im #{zuckerl_month_and_year zuckerl} mit der Sichtbarkeit: #{zuckerl.visibility}", class: 'txt')
    when zuckerl.live?
      content_tag(:div, 'Dein Zuckerl ist aktiv!', class: 'state') +
      content_tag(:div, "Dein Zuckerl ist gerade online mit der Sichtbarkeit: #{zuckerl.visibility}", class: 'txt')
    else
      content_tag(:div, 'Dein Zuckerl ist abgelaufen', class: 'state') +
      content_tag(:div, "Dein Zuckerl war im Monat #{zuckerl_month_and_year zuckerl} aktiv.", class: 'txt')
    end
  end

  def zuckerl_month(zuckerl)
    time = zuckerl.created_at || Time.now
    I18n.localize time.end_of_month+1.day, format: '%B'
  end

  def zuckerl_month_and_year(zuckerl)
    time = zuckerl.created_at || Time.now
    I18n.localize time.end_of_month+1.day, format: '%B %Y'
  end

  ZuckerlGraetzlPrice = 16.5
  ZuckerlAllDistrictsPrice = 175

  def zuckerl_price(zuckerl_visibility)
    if zuckerl_visibility == 'all_districts'
      number_to_currency(ZuckerlAllDistrictsPrice + (ZuckerlAllDistrictsPrice * 0.20))
    else
      number_to_currency(ZuckerlGraetzlPrice + (ZuckerlGraetzlPrice * 0.20))
    end
  end

end
