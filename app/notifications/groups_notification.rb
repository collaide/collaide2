class GroupsNotification < NotificationSystem::Base

  def create(group)
    t('notifications.groups.create', group: link_to(group, group_group_path(group)))
  end

  def invitation(invitation)
    t('notifications.groups.invitation', user: invitation.sender, group: link_to(invitation.group, group_group_path(invitation.group)))
    +
    simple_form_for(invitation) do

    end
  end
end