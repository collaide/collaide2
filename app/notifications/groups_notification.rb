class GroupsNotification < NotificationSystem::Base

  def create(group)
    t('notifications.groups.create', group: link_to(group, group_group_path(group)))
  end

  def invitation(invitation)
    if invitation.waiting_a_reply?
      t('notifications.groups.invitation', user: h(invitation.sender), group: h(invitation.group)) +
          link_to(t('dico.reply'), user_invitations_path(invitation.receiver), class: 'std-button')
    else
      t('notifications.groups.invitation_accepted', group: link_to(h(invitation.group), group_group_path(invitation.group))).html_safe
    end
  end
end