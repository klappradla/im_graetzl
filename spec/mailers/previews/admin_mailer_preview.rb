# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def new_zuckerl
    AdminMailer.new_zuckerl(Zuckerl.last)
  end
  def new_paid_going_to
    AdminMailer.new_paid_going_to(GoingTo.where(role: :paid_attendee).last)
  end
end
