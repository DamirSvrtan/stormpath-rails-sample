@stormpath
Feature: Authenticating user
  Scenario: User sign in
    Given existing user
    When I go to the new user session page
    And I sign in with username and password
    Then I should sign in successfully

  Scenario: User sign in with incorrect credentials
    Given existing user
    When I go to the new user session page
    And I sign in with incorrect username and password
    Then I should see login error