Feature: I want to test the files and folders repo of a group

  @javascript
  Scenario: I visit the index of an empty repo
    Given I am an authenticated member of a group
    When I visit the group's repo page
    Then I should see a message for empty repo
  Scenario: I visit the index of a repo
    Given I am an authenticated member of a group
    When I visit the group's repo page
    And The repo page has items
    Then I should see the items