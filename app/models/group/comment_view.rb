class Group::CommentView < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic, class_name: 'Group::Topic'
  belongs_to :comment, class_name: 'Group::Comment'
end