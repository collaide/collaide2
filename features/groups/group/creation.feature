Feature: I want to test the creation of a new group in different ways (logged in or not / not a member)

  @javascript
  Scenario: I want to create a new group when I am logged in
    Given I am authenticated
    And I visit my profile's page to see my groups
#    When I give a name and I press the button create a group
#    Then I should see the group's main page