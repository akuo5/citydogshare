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
    | name     | mix              | age | size            | gender | likes      | energy  | personality | user_id |
    | Princess | Labrador         | 1   | small (0-15)    | Female | cats       | high    | whatever    | 1       |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male   | dogs (all) | some    | lover       | 1       |

  And I am logged in
  And I am on the share dogs page

Scenario: I create a dog event
  Given I check "dogs_Princess"
  And I check "times_Morning"
  And I choose "my_location_My_House"
  When I press Schedule
  Then I should not see "Create Event"
  And I should see "Princess"
  And I should see "Location: My House"
  And I should see "Time: Morning"
<<<<<<< 336668bfb7cfb018aa5614fcc296d18a6a598342

Scenario: Not selecting a dog should throw an error
  Given I press "Schedule"
  Then I should see "Please select a dog to share"

Scenario: Not selecting a date should throw an error
  Given I check "dogs_Princess"
  And I check "times_Morning"
  And I press "Schedule"
  Then I should see "Please enter a valid start date"
  And I should see "Please enter a valid end date"

Scenario: Not selecting a time of day should throw an error
  Given I check "dogs_Princess"
  Given I press Schedule
  Then I should see "Please enter a time of day"


Scenario: Not selecting a dog should throw an error
  Given I press "Schedule"
  Then I should see "Please select a dog to share"

Scenario: Not selecting a date should throw an error
  Given I check "dogs_Princess"
  And I check "times_Morning"
  And I press "Schedule"
  Then I should see "Please enter a valid start date"
  And I should see "Please enter a valid end date"

Scenario: Not selecting a time of day should throw an error
  Given I check "dogs_Princess"
  Given I press Schedule
  Then I should see "Please enter a time of day"

Scenario: Event should show up on dog profile
  Given I check "dogs_Princess"
  And I check "times_Morning"
  And I choose "my_location_My_House"
  When I press Schedule
  Then I should not see "Create Event"
  When I follow the first "My Dogs"
  When I follow the dog named "Princess"
  Then I should see today's date
  #And I should see "Location: My House"
  And I should see "Time: Morning"

Scenario: Event should not display past events
  Given I have created an event for "Princess" 3 days ago
  And I am on my profile page
  When I follow the first "My Dogs"
  When I follow the dog named "Princess"
  Then I should not see "Time: Morning"

