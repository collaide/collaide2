Given(/^I am authenticated$/) do
  @user = create(:user)
  visit '/users/sign_in'
  fill_in 'sign_in_email', with: @user.email
  fill_in 'sign_in_password', with: @user.password
  click_button 'sign_in_button'
end

And(/^I visit my profile's page to see my groups$/) do
  visit user_groups_path(@user)
end

When(/^I give a name and I press the button create a group$/) do
  fill_in 'group_group_name', with: 'A group for testing'
  click_button 'Nouveau groupe'
end

Then(/^I should see the group's main page$/) do
  expect(page).to have_content 'A group for testing'
end

Given(/^I am an authenticated member of a group$/) do
  step('I am authenticated')
  @group = Group::Group.create(name: 'A group', user: @user)
end

When(/^I visit the group's repo page$/) do
  visit group_group_repo_items_path(@group)
end

Then(/^I should see a message for empty repo$/) do
  expect(page).to have_content 'Vous pouvez ajouter des fichiers'
end

And(/^The repo page has items$/) do
  @group.create_folder('test folder')
end

Then(/^I should see the items$/) do
  wait_for_ajax
  expect(page).to have_content('test folder')
end