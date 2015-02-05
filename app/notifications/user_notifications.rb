# You can use the I18n t and l methods to translate, as well routes and link helpers
# This file is an example file and should be updatedå
class UserNotifications < NotificationSystem::Base
  def hello_world(name)
    "hello #{name}!"
  end

  def hello_world2(numa, tibo)
    "hello #{numa} and #{tibo}"
  end

  def group_created(group, comment)
    "You created the group: #{group}. That's #{comment}"
  end
end