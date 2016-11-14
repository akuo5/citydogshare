Feature: Developers should be able to access a dog's profile though a puclic api

As a developer
So that I can display a dogs information on my website
I should be able to access any dog's public profile given I know its id

Background: User has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student1@berkeley.edu           | I love dogs  | not mornings   | 388 Cory Hall | 94720   | Berkeley | US      |
 And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped | availability |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    | blah         |
    | Pupper   | Labrador         | 2   | small (0-15)    | Male     | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |              |

Scenario: Get the dogs's profile information whose id is 1
  Given I make a request to the dog profile api with the id set to "1"
  Then I should see "Prince"
  And I should see "male"
  And I should see "Small (0-15)"
  And I should see "1"
  And I should see "Female"
  And I should see "High"
  And I should see "Labrador"
  
Scenario: Get all the dogs
  Given I make a request to see all dogs
  Then I should see "Princess"
  And I should see "Pupper"
  
Scenario: Get all the available dogs
  Given I make a request to see all available dogs
  Then I should see "Princess"
  And I should not see "Pupper"