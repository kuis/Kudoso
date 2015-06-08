Then(/^I should be redirected to "(.*?)"$/) do |redirectPath|
  expect(URI.parse(current_url).path).to eq(redirectPath)
end
