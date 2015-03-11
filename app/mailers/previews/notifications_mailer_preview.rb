class NotificationMailerPreview < ActionMailer::Preview

  def signup
    NotificationsMailer.signup(User.first)
  end

  def new_notification
    NotificationsMailer.new_notification(User.first, GroupsNotification.create!(:new_activity, values: Group::Group.first, users: User.first))
  end
end