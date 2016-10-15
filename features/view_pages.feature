Feature: User should see the pages displayed correctly, and the links work. 
  As a City Dog Share user
  In order to navigate the website
  I want to click on different links to take me to different pages.
  
  Scenario: User should see correct items on the home page
    Given PENDING
  Given I am on the homepage
  Then I should see "Browse Dogs"
  
  Scenario: Log in when I already have an account
    Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  And I am on the home page
  When I follow "Log In"
  Then I should be on the users page for "Batman"
  
  Scenario: User should be able to navigate to sign up page
    Given PENDING
  Given I am on the homepage
  When I follow "Sign Up"
  Then I should be on the users page for "Batman"
  
  Scenario: Log in when I already have an account
    Given PENDING
  Given the following users exist:
  | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability |
  | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights   |
  And I am on the home page
  When I follow "Log In"
  Then I should be on the users page for "Batman"
  
  
  Scenario: log in when account does not exist
    Given PENDING
  Given I am on the home page
  When I follow "Log In"
  Then I should be on the home page
  And I should see "User does not exist"
  
  
  