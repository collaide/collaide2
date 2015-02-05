# -*- encoding : utf-8 -*-
class NotificationSystem::Base < ActionView::Base
  include Rails.application.routes.url_helpers

  # For use, see the spec/models/app_notification_spec.rb
  def self.create!(method, values: nil, users: nil)
      NotificationSystem::Save.perform(self.to_s, method, values, users)
  end
end
