class Group::GroupCreation < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: I18n.t('groups.group_creation.errors.valid_email') }

  belongs_to :group, class_name: 'Group::Group'
end