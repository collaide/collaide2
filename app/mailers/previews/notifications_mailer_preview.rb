class NotificationMailerPreview < ActionMailer::Preview

  def signup
    NotificationsMailer.signup(User.first)
  end
end