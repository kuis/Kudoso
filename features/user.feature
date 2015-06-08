Feature: User
  Tests all the features around user signup and manipulation

  Scenario: Create a new user
    Given I am not authenticated
    When I signup with my name "John Doe" and email "doe@nowhere.com"
    Then A user with email "doe@nowhere.com" should exist
    And I should be redirected to "/wizard"
    And The wizard should be on step "2"

  Scenario: Add family members in step 2 of signup wizard
    Given I signup with my name "John Doe" and email "doe@nowhere.com"
    When I add a "child" named "Sue" with a birthday of "12/23/2001" and a password of "1234" via the wizard
    Then A family member with the username "sue" should exist
    And A family member with the name "Sue" should be printed on the screen
