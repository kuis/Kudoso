



Then(/^I should have a family named "(.*?)"$/) do |familyName|
  expect(Member.find_by_email(@email).family.name).to eq(familyName)
end