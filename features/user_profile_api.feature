Feature: Developers should be able to access a user's profile though a puclic api

As a developer
So that I can display a user's information on my website
I should be able to access any users's public profile given I know their id

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student1@berkeley.edu           | I love dogs  | not mornings   | 388 Cory Hall | 94720   | Berkeley | US      |
 And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Bubba    | Aidi             | 3   | medium (16-40)  | Female   | dogs (all) | some    | lover       | 2       | 37.8611110 | -122.3079169 | true  | true    |

Scenario: Get the user's profile information
  Given I make a request to the user profile api with the id set to "1"
  Then I should see "Bruce Wayne"
  And I should not see "387 Soda Hall"
  And I should not see "Berkeley"
  And I should not see "94720"
  And I should not see "US"
  And I should not see "male"
  And I should see "looking"
  And I should not see "(555)228-6261"
  And I should see "not_batman@wayneenterprises.com"
  And I should see "I love bats"
  And I should see "not nights"
  And I should see "1"