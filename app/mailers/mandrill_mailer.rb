class MandrillMailer < BaseApiMailer
  include MailUtils

  def initialize(template:nil, message:nil)
    @template = template
    @message = message
  end

  def deliver
    send_mail if @template && @message
  end

  private

  attr_reader :template, :message

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(MANDRILL_API_KEY)
  end

  def send_mail
    retries = 2
    begin
      mandrill_client.messages.send_template(@template, [], @message)
    rescue Mandrill::Error
      retries -= 1
      retry if retries >= 0
    end
  end

end
