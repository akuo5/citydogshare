@facebook_test
Feature: Users should be able to view their profile.

As a personal user
So that I can verify that my information is correct
I should be able to view the current state of my profile

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student1@berkeley.edu           | I love dogs  | not mornings   | 388 Cory Hall | 94720   | Berkeley | US      |
  And I am logged in

Scenario: View user profile information
  Given I am on the users page for "Batman"
  Then I should see "Bruce Wayne"
  And I should see "387 Soda Hall"
  And I should see "Berkeley"
  And I should see "94720"
  And I should see "US"
  And I should see "Male"
  And I should see "looking"
  And I should see "(555)228-6261"
  And I should see "not_batman@wayneenterprises.com"
  And I should see "I love bats"
  And I should see "not nights"

Scenario: Page shows flash notice when trying to view user who does not exist
  When I am on the profile page for non-existent user
  Then I should see "The user you entered does not exist."
