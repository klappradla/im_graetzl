# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def new_zuckerl
    AdminMailer.new_zuckerl(Zuckerl.last)
  end
end
