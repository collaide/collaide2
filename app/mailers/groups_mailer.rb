class GroupsMailer < ApplicationMailer

  def new_invitation(email_invitation)
    @user = email_invitation.sender
    @group = email_invitation.group
    @message = email_invitation.message
    @secret_token = email_invitation.secret_token
    @email_id = email_invitation.id

    mail to: email_invitation.email, subject: I18n.t('mailers.groups.new_invitation.subject', user: @user.to_s, group: @group.to_s)
  end
end