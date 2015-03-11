module GroupsMailerHelper

  def reply_link(invitation, status)
    group_group_invitation_url(group_group_id: invitation.group, id: invitation, status: status)
  end

  def email_reply_link(group_id, email_id, secret_token, status)
    group_group_email_invitations_url(group_group_id: group_id, id: email_id, secret_token: secret_token, status: status)
  end
end