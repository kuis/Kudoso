Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

When(/^I signup with my name "(.*?)"$/) do |myName|
  @firstName = myName.split(' ').first
  @lastName = myName.split(' ').last
  @email = "#{@firstName[0]}#{@lastName}@example.com"
  visit '/users/sign_up'
  fill_in 'user_email', with: @email
  fill_in 'user_password', with: 'password', exact: true
  fill_in 'user_password_confirmation', with: 'password', exact: true
  fill_in 'user_first_name', with: @firstName, exact: true
  fill_in 'user_last_name', with: @lastName, exact: true
  click_button 'Sign up'
end

Then(/^I should be created as a parent$/) do
  click_link 'My Family'

end