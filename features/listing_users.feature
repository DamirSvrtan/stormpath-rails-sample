@stormpath
Feature: Listing users with stormpath accounts
  Background:
    Given I am logged in

  Scenario: List users
    When I go to the users page
    Then I should see user details
