# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def new_zuckerl
    zuckerl = FactoryBot.create :zuckerl
    AdminMailer.new_zuckerl(zuckerl).deliver_now
    zuckerl.destroy
  end
end
