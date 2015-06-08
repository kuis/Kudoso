Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

When(/^I signup with my name "(.*?)" and email "(.*?)"$/) do |myName, myEmail|
  @firstName = myName.split(' ').first
  @lastName = myName.split(' ').last
  # @email = "#{@firstName[0]}#{@lastName}@example.com"
  visit '/users/sign_up'
  fill_in 'user_email', with: myEmail #@email
  fill_in 'user_password', with: 'password', exact: true
  fill_in 'user_password_confirmation', with: 'password', exact: true
  fill_in 'user_first_name', with: @firstName, exact: true
  fill_in 'user_last_name', with: @lastName, exact: true
  click_button 'Sign up'
  @current_user = User.find_by_email(myEmail)
end

Then(/^A user with email "(.*?)" should exist$/) do |myEmail|
  expect(User.find_by_email(myEmail)).not_to eq(nil)
end

Then(/^I should be created as a parent$/) do
  click_link 'My Family'
end

Then(/^The wizard should be on step "(.*?)"$/) do |step|
  expect(@current_user.wizard_step).to eq(step.to_i)
end

Then(/^A family member with the username "(.*?)" should exist$/) do |username|
  expect(@current_user.family.members.where(username: username).first).not_to eq(nil)
end