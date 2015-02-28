class NotificationsFromGroupActivities

  def self.perform(one_hour)
    cron_job = CronJob.where(job_name: 'group_activities').take
    if cron_job.nil?
      create_notifications(Activity::Activity.where(trackable_type: 'Group::Group'))
    else
      create_notifications(Activity::Activity.where(trackable_type: 'Group::Group').where('created_at > ?', cron_job.start_at), one_hour: one_hour)
    end

  end

  private

  def create_notifications(activities, one_hour: false)
    return if activities.size <= 1
    activities.each do |activity|
      group = activity.trackable
      group.group_members.each do |member|
        next if member.sent_notification.never?
        next if one_hour and member.sent_notification.each_day?
        GroupsNotification.create!(:new_activity, values: [group], owner: user)
      end
    end
  end
end
