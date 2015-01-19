



Then(/^I should have a family named "(.*?)"$/) do |familyName|
  user = User.last
  expect(user.family.name).to eq(familyName)
end