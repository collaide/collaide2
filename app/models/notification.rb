# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: app_notifications
#
#  id          :integer          not null, primary key
#  class_name  :string(255)
#  method_name :string(255)
#  values      :string(255)
#  is_viewed   :boolean          default(FALSE)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Notification < ActiveRecord::Base

  after_create :sent_email
  belongs_to :user

  serialize :values

  validates_presence_of :class_name
  validates_presence_of :method_name
  validates_presence_of :values
  validates_presence_of :user

  default_scope { order(:created_at => :desc) }

  def print_message
    klass = class_name.constantize.new
    method_variables = values.map do |value|
      gid = GlobalID::Locator.locate(value)
      gid.nil? ? value : gid
    end
    klass.send(method_name.to_sym, *method_variables)
  end

  private

  #Send an email to the user when a new notification is created if he wish it
  def sent_email
    return unless self.user.sent_email.always?
    NotificationsMailer.new_notification(self.user, self).deliver_later
  end
end
