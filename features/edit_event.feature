@facebook_test

Feature: User should be able to edit their dog's event

As a dog parent
In order to change the day I want a sitter
I want to edit my dog's event

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country | id |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      | 1  |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 94720   | Berkeley | US      | 2  |

  And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 2       | true  | true    |

  And I have created an event for "Princess" today
  And I am logged in
  And I am on my calendar page

Scenario: User should be able to delete their dog's event
  When I follow "Edit"
  Then I should be on the edit event page
  And I should see "Edit Princess's Event"
  When I press "Delete Event"
  Then I should be on my calendar page
  And I should see "Your event has been deleted."

Scenario: User should be able to edit their dog's event
  When I follow "Edit"
  And I check "times_Afternoon"
  And I choose "my_location_Your_House"
  And I press "Schedule"
  Then I should be on my calendar page
  And I should see "Time: Morning, Afternoon"
  And I should see "Location: Your House"

Scenario: User should not be able to save an incomplete event
  When I follow "Edit"
  And I uncheck "times_Morning"
  And I press "Schedule"
  Then I should see "Please enter a time of day"

Scenario: I should not be able to edit another users event
  When I do not care about dog location
  And I follow the first "Browse Dogs"
  And I check "Male"
  And I press "Search Dogs"
  And I should see "Spock"
  Then I should not see "Edit"

