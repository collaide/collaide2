# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/signup
  def signup
    NotificationsMailer.signup
  end

end
