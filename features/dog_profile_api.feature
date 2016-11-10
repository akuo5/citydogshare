Feature: Developers should be able to access a dog's profile though a puclic api

As a developer
So that I can display a dogs information on my website
I should be able to access any dog's public profile given I know its id

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student1@berkeley.edu           | I love dogs  | not mornings   | 388 Cory Hall | 94720   | Berkeley | US      |
 And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |

Scenario: Get the dogs's profile information 
  Given PENDING
  Given I make a request to the user profile api with the id set to "1"
  Then I should be given a Json string
  And I should see "Prince"
  And I should see "Male"
  And I should see "medium (16-40)"
  And I should see "anxious"
  And I should see "whatever"
  And I should see "dogs (all)"
  And I should see "cats"
  And I should see "some"
  And I should see "Hiya!"
  And I should see "I am a dog."
  And I should see "None"
  And I should see "Never"