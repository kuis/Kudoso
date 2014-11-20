Feature: Manage Families
  Families should contain groups of users and members
  Family information should be kept private and secure

  Scenario: Create a new family when a new user signs up
    Given I am not authenticated
    When I signup with my name "John Doe"
    Then I should be created as a parent
    And I should have a family named "Doe Household"
