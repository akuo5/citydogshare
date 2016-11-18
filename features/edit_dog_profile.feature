@facebook_test
Feature: Users should be able to edit their dog's profile

As a user
In order to update my dog's information
I want to edit my dog's profile

Background: User and dog is in database
  Given the following users exist:
    | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country | id |
    | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      | 1  |
    | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 94720   | Berkeley | US      | 2  |
  
  And the following dogs exist:
    | name     | mix              | age | size            | gender   | likes      | energy  | personality | user_id | latitude   | longitude    | fixed | chipped |
    | Princess | Labrador         | 1   | small (0-15)    | Female   | cats       | high    | whatever    | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Spock    | Aidi             | 3   | medium (16-40)  | Male     | dogs (all) | some    | lover       | 1       | 37.8611110 | -122.3079169 | true  | true    |
    | Bubba    | Aidi             | 3   | medium (16-40)  | Female   | dogs (all) | some    | lover       | 2       | 37.8611110 | -122.3079169 | true  | true    |
  And I am logged in

Scenario: User edits his dog's information
  And I am on the users page for "Batman"
  When I follow the first "My Dogs"
  And I follow the dog named "Princess"
  And I follow "Edit"
  And I fill in "dog_name" with "Prince"
  And I select "Male" from "dog_gender"
  And I select "medium (16-40)" from "dog_size"
  And I select "anxious" from "dog_personalities"
  And I select "dogs (all)" from "dog_likes"
  And I select "some" from "dog_energy_level"
  And I select "Yes" from "dog_fixed"
  And I select "Yes" from "dog_chipped"
  And I fill in "dog_motto" with "Hiya!"
  And I fill in "dog_description" with "I am a dog."
  And I fill in "dog_health" with "None"
  And I select "Available" from "dog_availability"
  And I press the first "Save Changes"
  Then I should see "Prince"
  And I should see "Male"
  And I should see "Medium (16-40)"
  And I should see "Anxious"
  And I should see "Whatever"
  And I should see "Dogs (all)"
  And I should see "Cats"
  And I should see "Some"
  And I should see "Hiya!"
  And I should see "I am a dog."
  And I should see "None"
  And I should see "Available"

Scenario: User should not be able to edit another user's dog
  Given I do not care about dog location
  And I am on the search dogs page
  And I should see "Bubba"
  And I follow the first "Bubba"
  Then I should not see "Edit"
