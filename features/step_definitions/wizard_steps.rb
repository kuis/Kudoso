When(/^I add a "(.*?)" named "(.*?)" with a birthday of "(.*?)" and a password of "(.*?)" via the wizard$/) do |member_type, first_name, birthday, password|
  if member_type == 'parent'
    check 'member_parent'
  end
  fill_in 'member_first_name', with: first_name, exact: true
  fill_in 'member_birth_date', with: birthday, exact: true
  fill_in 'member_password', with: password, exact: true
  click_button 'Add Member'
  wait_for_ajax
end

Then(/^A family member with the name "(.*?)" should be printed on the screen$/) do |first_name|
  expect(find('.family_members')).to have_content( first_name.downcase )
end