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
  When I follow the first "Login with Facebook"
  Then I should be on the users page for "Batman"
  
Scenario: Sign up with facebook if I am a new user
  Given I am on the homepage
  When I follow the first "Login with Facebook"
  Then I should be on the users page for "Batman"

Scenario: Sign up authentication fails
  Given I am on the homepage
  When I follow the first "Login with Facebook"
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."

Scenario: Log out when logged in to the site
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   | 
  And I am logged in
  And I am on the users page for "Batman"
  When I follow "Sign Out"
  Then I should be on the home page
  And I should see "Login with Facebook"

Scenario: Log in authentication fails
  Given I am on the homepage
  When I follow the first "Login with Facebook"
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."

Scenario: Log in to Facebook using Facebook auth
  Given I am on the homepage
  And When I follow the first "Login with Facebook"
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."


Scenario: Log in authentication fails
  Given I am on the homepage
  And When I follow the first "Login with Facebook"
  And my authentication fails
  Then I should be on the home page
  And I should see "Something went wrong with the authentication. Please try again."
