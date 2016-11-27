@facebook_test
Feature: Users should be able to switch to a pro user

As a professional dog walker
I want to be able to use the app to find dogs and manage my dog walking schedule
Thus, I would want to be able to switch to a "pro user" profile

Background: User and other users are in database
  Given PENDING
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 12345   | Berkeley | US      |
  
 And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Bubba    | Aidi             | 3   | medium (16-40)  | Female   | dogs (all) | some    | lover       | 2       | 37.8611110 | -122.3079169 | true  | true    |
  
  And I am logged in
  And I am on the users page for "Batman"


Scenario: Switch to pro user from regular user
  Given PENDING
  Given I am on the users page for "Batman"
      And I flip the toggle button for "Pro User" to "No"
  Then I should not see I am a "Pro User"
    Then I flip the toggle button for "Pro User" to "Yes"
  Then I should be able to see that I am a "Pro User"

Scenario: User's page shows link to calendar button when user is a pro user
  Given PENDING
  Given I am on the users page for "Batman"
    And I flip the toggle button for "Pro User" to "No"
  Then I should not see "My Pro Calendar"
    Then I flip the toggle button for "Pro User" to "Yes"
  Then I should be able to see that I am a "Pro User"
  Then I should see "My Pro Calendar"

Scenario: Sidebar shows link to calendar when user is a pro user
  Given PENDING
    Given I am on the users page for "Batman"
    And I flip the toggle button for "Pro User" to "No"
    And the sidebar is open
  Then I should not see "My Pro Calendar"
    Then I close the sidebar
    Then I flip the toggle button for "Pro User" to "Yes"
  And the sidebar is open
  Then I should see "My Pro Calendar"

Scenario: Clicking pro button redirects to other app
  Given PENDING
    Given I am on the users page for "Batman"
    Then I flip the toggle button for "Pro User" to "Yes"
  Then I follow the first "My Pro Calendar"
  Then I should be on the homepage for "Calendar App" 
  
Scenario: Pro user can add someone else's dog to their calendar
  Given PENDING
    Given I am on the users page for "Juan"
    And I follow the dog named "Princess"
  Then I follow the first "Add to my schedule"
  Then I should be on the calendar page for "Calendar App" 
  
#   Test API Call 