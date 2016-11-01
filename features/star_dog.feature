@facebook_test
Feature: Users should be to "star" a dog

As a user
In order to keep track of dogs that I like
I want to be able to star a dog

Background: Users and dogs are in database
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country | id |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94704   | Berkeley | US      | 1  |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 12345   | Berkeley | US      | 2  |
  
  And the following dogs exist:
  
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Bubba    | Aidi             | 3   | medium (16-40)  | Female   | dogs (all) | some    | lover       | 2       | 37.8611110 | -122.3079169 | true  | true    |
  And I do not care about dog location

Scenario: User must be logged in to star a dog from search results
  And I am on the search dogs page
  Then I should not see a star 

Scenario: User can star dog from search results
  And I am logged in
  And I am on the search dogs page
  And I click a star for dog with dog id "3"
  And I follow the first "My Favorites"
  Then I should see "Bubba"

Scenario: User can star dog from dog profile
  And I am logged in
  And I am on the search dogs page
  And I follow "Bubba"
  And I click a star for dog with dog id "3"
  And I follow the first "My Favorites"
  Then I should see "Bubba"

Scenario: User should be able to star their own dog
  And I am logged in
  And I am on the users page for "Batman"
  When I follow the first "My Dogs"
  And I follow the dog named "Princess"
  And I click a star for dog with dog id "1"
  Then I should see "1"
  And I follow the first "My Favorites"
  Then I should see "Princess"

Scenario: User should be able to unstar a dog from search results
  And I am logged in
  And I am on the search dogs page
  And I click a star for dog with dog id "3"
  And I click a star for dog with dog id "2"
  And I click a star for dog with dog id "3"
  And I follow the first "My Favorites"
  Then I should not see "Bubba"
  And I should see "Spock"

Scenario: User should be able to unstar a dog from dog profile
  And I am logged in
  And I am on the search dogs page
  And I follow "Bubba"
  And I click a star for dog with dog id "3"
  Then I should see "1"
  And I click a star for dog with dog id "3"
  Then I should see "0"
  And I follow the first "My Favorites"
  Then I should not see "Bubba"

