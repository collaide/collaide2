require 'rails_helper'

RSpec.describe Notification, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:u2) { FactoryGirl.create(:user) }

  it 'has an user with a notification' do
    UserNotifications.create!(
        :hello_world, #la méthode de la notif
        values: 'numa', # les paramètres de la notification
        users: user
    )
    expect(user.notifications.first.print_message).to include 'numa'
  end
  it 'has an array of users with a notification with more than one param' do
    # You save which class, method and params to call for printing the notification message
    UserNotifications.create!(
        :hello_world2, #la méthode de la notif
        values: ['numa', 'tibo'], # les paramètres de la notification
        users: [user, u2]
    )
    # The message printed is from the class userNotification and the method hello_world2
    expect(user.notifications.first.print_message).to include 'numa', 'tibo'
  end

  it 'has activerecord object' do
    group_name = 'MY awsome groupe'
    @group = Group::Group.create(name: group_name)
    # It is allowed to instances of models as values. There are saved string in the db
    # and automatically retrived when the method to print the notification is called
    # Others instance objects are just saved and printed as string
    UserNotifications.create!(:group_created, values: [@group, 'nice'], users: user)

    expect(user.notifications.first.print_message).to include group_name, 'nice'
  end
end
