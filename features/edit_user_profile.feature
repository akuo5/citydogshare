@facebook_test
Feature: Users should be able to edit their profile.

As a user
In order to change my information
I want to edit my profile

Background: User and other users are in database
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |

  And I am logged in
  And I am on the users page for "Batman"
  And I follow "Edit Profile"

Scenario: Page shows flash notice when user tries to edit another profile
  When I am on the edit page for non-existent user
  Then I should see "You may only edit your own profile."

Scenario: Page shows error when phone number is wrong format
  When I fill in "user_phone_number" with "1235"
  When I press "Save Changes"
  Then I should see "Bad format for phone number."

Scenario: Page shows error when zipcode is wrong format
  When I fill in "user_zipcode" with "1235"
  When I press "Save Changes"
  Then I should see "Bad format for zipcode."

Scenario: Sucessfully update some of profile
  And I fill in "user_status" with "Sharing"
  And I fill in "user_description" with "I think I should make City Bat Share."
  And I press "Save Changes"
  Then I should be on the users page for "Batman"
  And I should see "387 Soda Hall"
  And I should see "Berkeley"
  And I should see "94720"
  And I should see "US"
  And I should see "(555)228-6261"
  And I should see "Sharing"
  And I should see "I think I should make City Bat Share."
  And I should see "not nights"

Scenario: Sucessfully update all of profile
  When I fill in "user_address" with "2128 Oxford St"
  And I fill in "user_city" with "Berkeley"
  And I fill in "user_zipcode" with "94704"
  And I fill in "user_country" with "US"
  And I fill in "user_status" with "Sharing"
  And I fill in "user_phone_number" with "(510)123-1234"
  And I fill in "user_description" with "I think I should make City Bat Share."
  And I fill in "user_availability" with "Never"
  And I press "Save Changes"
  Then I should be on the users page for "Batman"
  And I should see "2128 Oxford St"
  And I should see "Berkeley"
  And I should see "94704"
  And I should see "Sharing"
  And I should see "(510)123-1234"
  And I should see "I think I should make City Bat Share."
  And I should see "Never"

Scenario: No changes made when changes canceled
  When I fill in "user_address" with "2128 Oxford St"
  And I fill in "user_city" with "Berkeley"
  And I fill in "user_zipcode" with "94704"
  And I fill in "user_country" with "US"
  And I fill in "user_status" with "Sharing"
  And I fill in "user_phone_number" with "(510)123-1234"
  And I fill in "user_description" with "I think I should make City Bat Share."
  And I fill in "user_availability" with "Never"
  And I follow "Cancel"
  Then I should be on the users page for "Batman"
  And I should see "387 Soda Hall"
  And I should see "Berkeley"
  And I should see "94720"
  And I should see "US"
  And I should see "looking"
  And I should see "(555)228-6261"
  And I should see "I love bats"
  And I should see "not nights"