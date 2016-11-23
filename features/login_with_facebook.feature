@facebook_test
Feature: User can log in using facebook
  As a City Dog Share user
  In order to access my account or make a new account
  I want to log in to City Dog Share


Scenario: Log in when I already have an account
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  And I am on the home page
  When I press the "Sign Up" button
  And I should see the login popup
  And I follow the first "Login"
  Then I should be on the users page for "Batman"


  
Scenario: Sign up with facebook if I am a new user
  Given PENDING
  Given I am on the homepage
  When I press the "Sign Up" button
  Then I follow the first "Sign Up With Facebook"
  Then I should be on the users page for "Batman"
  
Scenario: Sign up with facebook should fail if I am an existing user
Scenario: Sign up with facebook should log user into account
  Given I am on the homepage
  When I press the "Sign Up" button
  Then I follow the first "Sign Up With Facebook"
  Then I should be on the users page for "Batman"

Scenario: Sign up authentication fails
  Given I am on the homepage
  When I press the "Sign Up" button
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."

Scenario: Log out when logged in to the site
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   | 
  And I am logged in
  And I am on the users page for "Batman"
  When I follow the first "Sign out"
  Then I should be on the home page
  And I should see "Sign Up"

Scenario: Log in authentication fails
  Given I am on the homepage
  When I press the "Sign Up" button
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."

Scenario: Log in to Facebook using Facebook auth
  Given I am on the homepage
  When I press the "Sign Up" button
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."

Scenario: Log in authentication fails

  Given I am on the homepage
  When I press the "Sign Up" button
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."




# Scenarios 11-10
# Want to change login redirect from user's profile to home page


Scenario: Log in when I already have an account
  Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  And I am on the home page
  When I press the "Sign Up" button
  And my session has expired
  When I follow the first "Login"
  Then I should be on the reauthentication page
  And I click sign in with "Batman"
  Then I should be on the home page
  
Scenario: Sign up when another user is remotely logged in
  Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  And I am on the home page
  And I am signed out
  When I press the "Sign Up" button
  Then I follow the first "Sign Up With Facebook"
  Then I should be on the home page
  
  Scenario: Log in when no one is logged in
  Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  | Grayson      | Dick    | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6262 | not_robin@wayneenterprises.com | I love robins  | not nights  |
  And I am on the home page
  When I follow the first "Sign in with Facebook"
  Then I should be on the reauthentication page
  And I click sign in with "another user"
  And I follow "Batman"
  And I enter password "12345"
  Then I should be on the home page
  
  Scenario: Log in to another user account
  Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  | Grayson      | Dick    | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6262 | not_robin@wayneenterprises.com | I love robins  | not nights  |
  And I am on the home page
  And I am logged in as "Batman"
  And I follow "Sign out"
  Then I should be on the home page
  Then I follow "Log in with Facebook"
  Then I should be on the reauthentication page
  And I should see "Batman"
  And I click sign in with "another user"
  And I follow "Robin"
  Then I should be on the home page

