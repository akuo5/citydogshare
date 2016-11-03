Feature: Users should be able to search for a dog

As a dog-sitter
In order to sit a dog
I would like to search for dogs to sit

Background: user has been added to the database and logged in
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country | id |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      | 1  |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 12345   | Berkeley | US      | 2  |
  
  And the following dogs exist:

    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Bubba    | Aidi             | 3   | medium (16-40)  | Female   | dogs (all) | some    | lover       | 2       | 30.0506448 | -89.95475610 | true  | true    |
  And my zipcode is "94704"
  And I am on the search dogs page

Scenario: Only see dogs within 100 miles by default
  When I press "Search Dogs"
  And I should see "Princess"
  And I should see "Spock"
  And I should not see "Bubba"

Scenario: Should see dogs within specified range 
  When I fill in "radius" with "100000000000"
  When I press "Search Dogs"
  And I should see "Princess"
  And I should see "Spock"
  And I should see "Bubba"

Scenario: Should give dogs in order of closest distance
  When I fill in "radius" with "100000000000"
  And I fill in "zipcode" with "12345"
  When I press "Search Dogs"
  And I should see "Princess"
  And I should see "Spock"
  And I should see "Bubba"
  And "Bubba" should appear before "Spock"
  And "Bubba" should appear before "Princess"

Scenario: Filter by gender
  When I do not care about dog location
  When I check "gender[Male]"
  And I press "Search Dogs"
  Then I should see "Spock"
  And I should not see "Princess"

Scenario: Filter by Age
  When I do not care about dog location
  When I check "age[0]"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: Filter by Size
  When I do not care about dog location
  When I check "size[small (0-15)]"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: Filter by Likes
  When I do not care about dog location
  When I check "like[cats]"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: Filter by Energy
  When I do not care about dog location
  When I check "energy_level[high]"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: Filter by Energy
  When I do not care about dog location
  When I check "personality[whatever]"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: Filter by Mix
  When I do not care about dog location
  When I select "Labrador" from "mix"
  And I press "Search Dogs"
  Then I should see "Princess"
  And I should not see "Spock"

Scenario: No dogs match criteria
  When I do not care about dog location
  When I check "size[large (41-100)]"
  And I press "Search Dogs"
  Then I should see "No Dogs Found"





