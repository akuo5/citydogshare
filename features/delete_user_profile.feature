# @facebook_test
# Feature: Users should be able to delete their profile.

# As a user
# In order to stop using City Dog Share
# I want to delete my profile

# Background: User and other users are in database
#   Given the following users exist:
#     | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   |
#     | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     |
#   And I am logged in
#   And I am on the users page for "Batman"
#   And I press "Edit Profile"

# Scenario: Users deletes profile
#   When I press "Delete User"
#   Then I should be on the home page
#   When I follow "Login with Facebook"
#   And I should see "User does not exist"