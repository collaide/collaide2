Given(/^I am authenticated$/) do
  @user = create(:user)
  visit '/users/sign_in'
  fill_in 'sign_in_user_email', with: @user.email
  fill_in 'sign_in_user_password', with: @user.password
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