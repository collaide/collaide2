class GroupsMailer < ApplicationMailer

  def new_invitation_from_email(email_invitation)
    @user = email_invitation.sender
    @group = email_invitation.group
    @message = email_invitation.message
    @secret_token = email_invitation.secret_token
    @email_id = email_invitation.id

    mail to: email_invitation.email, subject: I18n.t('mailers.groups.new_invitation.subject', user: @user.to_s, group: @group.to_s)
  end

  def new_invitation(invitation)
    @invitation = invitation

    mail to: invitation.receiver.email, subject: I18n.t('mailers.groups.new_invitation.subject', user: invitation.receiver, group: invitation.group)
  end
end