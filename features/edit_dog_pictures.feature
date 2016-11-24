Feature: Users should be able to delete their dog's pictures and videos 

As a user
In order to update my dog's information
I want to delete my dog's pictures and videos 

Background: User and dog is in database
  Given PENDING 
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

Scenario: User should be able to delete their dog's photo 
  Given PENDING 

Scenario: User should be able to delete their dog's video
  Given PENDING 