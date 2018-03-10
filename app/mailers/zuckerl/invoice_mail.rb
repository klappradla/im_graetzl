class Zuckerl::InvoiceMail < Zuckerl::BaseMail
  MAIL_TEMPLATE = 'zuckerl-successfully-paid-and-invoice'
  SUBJECT = 'Zahlungsbestätigung deines Grätzlzuckerls'

  private

  def template
    MAIL_TEMPLATE
  end

  def message
    {
      to: [ { email: @user.email } ],
      from_email: FROM_EMAIL,
      from_name: FROM_NAME,
      subject: SUBJECT,
      merge_vars: [rcpt: @user.email, vars: message_vars],
      bcc_address: 'michael@imgraetzl.at'
    }
  end

  def message_vars
    [
      { name: 'username', content: @user.username },
      { name: 'payment_reference', content: @zuckerl.payment_reference },
      { name: 'payment_date', content: Date.today.strftime('%d.%m.%Y') },
      { name: 'location_name', content: @location.name },
      { name: 'location_url', content: graetzl_location_url(@location.graetzl, @location, URL_OPTIONS) },
      { name: 'zuckerl_url', content: zuckerls_user_url(URL_OPTIONS) },
      { name: 'zuckerl_period', content: start_time },
      { name: 'billing_address', content: billing_address_vars },
    ]
  end

  def start_time
    I18n.localize @zuckerl.created_at.end_of_month+1.day, format: '%B %Y'
  end

  def billing_address_vars
    billing_address = @location.billing_address
    if billing_address
      {
        first_name: billing_address.first_name,
        last_name: billing_address.last_name,
        company: billing_address.company,
        street: billing_address.street,
        zip: billing_address.zip,
        city: billing_address.city,
        country: billing_address.country
      }
    else
      nil
    end
  end
end
