class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.signup.subject
  #
  def signup(user)
    @user = user
    mail to: user.email
  end

  def new_notification(user, notification)
    @user = user
    @notification = notification
    mail to: user.email
  end
end
