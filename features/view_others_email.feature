# @facebook_test
# Feature: Users should be able to switch to a pro user

# As a professional dog walker
# I want to be able to use the app to find dogs and manage my dog walking schedule
# Thus, I would want to be able to switch to a "pro user" profile

# Background: User and other users are in database
#   Given PENDING
#   Given the following users exist:
#     | last_name  | first_name | location              | gender | image                      | status  | phone_number  | email                           | description  | availability   | address       | zipcode | city     | country |
#     | Wayne      | Bruce      | Bat Cave, Gotham City | male   | http://tinyurl.com/opnc38n | looking | (555)228-6261 | not_batman@wayneenterprises.com | I love bats  | not nights     | 387 Soda Hall | 94720   | Berkeley | US      |
#     | Pinzon     | Juan       | Berkeley, California  | male   | http://tinyurl.com/okrw3vd | looking | (555)123-1234 | student2@berkeley.edu           | I love dogs  | not mornings   | 387 Cory Hall | 12345   | Berkeley | US      |
#   And I am logged in
#   And I am on the users page for "Batman"


# Scenario: See email button
#   Given PENDING
#   Given I am on the users page for "Juan"
#   Then I should see "Email Juan"
