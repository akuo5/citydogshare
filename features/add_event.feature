@facebook_test
Feature: User should be able to share their dog by adding an event

As a dog parent
In order to find a sitter on a specific day
I want to post a dog event that others can see

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country | id |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      | 1  |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 94720   | Berkeley | US      | 2  |
  
  And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | true  | true    |

  And I am logged in
  And I am on the share dogs page

Scenario: I create a dog event
  Given I select "Princess" from "event_dogs"
  And I select "My Place" from "event_location"
  And I fill in "event_start_date" with today
  And I fill in "event_end_date" with tomorrow
  And I press "Schedule"
  Then I should not see "Create Event"
  And I should see "Princess"
  And I should see "Location My Place"
  And I should see today
  And I should see tomorrow

Scenario: Empty event form should throw an error
  Given I press "Schedule"
  Then I should see "Please select the dogs you want to share"
  Then I should see "Please select a location"
  Then I should see "Please enter a start date"

Scenario: Selecting a start date before an end date should throw an error
  Given I select "Princess" from "event_dogs"
  And I select "My Place" from "event_location"
  And I fill in "event_start_date" with tomorrow
  And I fill in "event_end_date" with today
  And I press "Schedule"
  Then I should see "Start date must be before end date"

Scenario: Selecting start dates in the past should throw an error
  And I select "Princess" from "event_dogs"
  And I select "My Place" from "event_location"
  And I fill in "event_start_date" with yesterday
  And I fill in "event_end_date" with tomorrow
  And I press "Schedule"
  Then I should see "Start date has passed"

Scenario: Selecting end dates in the past should throw an error
  And I select "Princess" from "event_dogs"
  And I select "My Place" from "event_location"
  And I fill in "event_start_date" with yesterday
  And I fill in "event_end_date" with yesterday
  And I press "Schedule"
  Then I should see "End date has passed"

Scenario: Event should show up on dog profile
  # Given PENDING
  Given I select "Princess" from "event_dogs"
  And I select "My Place" from "event_location"
  And I fill in "event_start_date" with today
  And I fill in "event_end_date" with today
  When I press "Schedule"
  Then I should not see "Create Event"
  When I follow the first "My Dogs"
  And I follow the dog named "Princess"
  Then I should see today
  And I should see "Location My Place"
