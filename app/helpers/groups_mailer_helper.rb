module GroupsMailerHelper

  def reply_link(invitation, status)
    group_group_invitation_url(group_group_id: invitation.group, id: invitation, status: status)
  end
end