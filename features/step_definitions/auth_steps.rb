## Step Definitions for Facebook Login and Sign Up ##
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    new_user = User.create(user)
    new_user.uid = "12345"
    new_user.save
  end
end


Given /^I am logged in$/ do  
  visit "/auth/facebook?type=login"
end  

Given /^my authentication fails$/ do
  visit "/auth/failure"
end

When /^I click the "Sign Out"$/ do
  puts(page.body)
  click_link('Sign out')
  
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link, :match => :first)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button, :match => :first)
end


When /^(?:|I )press the "Sign Up" button$/ do
  # puts(page.body)
  click_link('Sign Up')
end


When /^(?:|I )press the first "([^"]*)"$/ do |button|
  first(:button, button).click

end



When /^(?:|I )press the "Sign Up" button$/ do
  # puts(page.body)
  click_link('Sign Up')
end


When /^(?:|I )press the first "([^"]*)"$/ do |button|
  first(:button, button).click

end


When /^(?:|I )follow the first "([^"]*)"$/ do |link|
  first(:link, link).click
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value, :match => :first)
end

When /^(?:|I )fill in the first "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value, :match => :first)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|I )should see the login popup$/ do
  if page.respond_to? :should
    page.should have_content('Login')
    find_link('Login').visible?
  else
    assert page.has_content('Login')

  end
end

Given /I make a request to the user profile api with the id set to "([^"]*)"/ do |id|
  visit path_to("user api")
end

Given /I make a request to the dog profile api with the id set to "([^"]*)"/ do |id|
  visit path_to("dog api")
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should_not have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field, match: :first)
end

Given /^PENDING/ do
  pending

# Auth login, steps 


Then(/^I click sign in with "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I am logged in as "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I enter password "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I am signed out$/) do
  pending # Write code here that turns the phrase above into concrete actions
end


# Pro User step definitons 

Given(/^I flip the toggle button for "([^"]*)" to "([^"]*)"$/) do |arg1, boolean|
  if boolean == "No"
    uncheck 'toggle'
  elsif boolean == "Yes"
    check 'toggle'
  end
end


Then(/^I should see that I am (.+) a "([^"]*)"$/) do |arg1, arg2|
  current_user = User.find(1)
  if arg1 == "not"
    assert_equal current_user.is_pro, false
  else
    assert_equal current_user.is_pro, true
  end
end

Given(/^the sidebar is open$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I close the sidebar$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the pro user option$/) do
  if page.respond_to? :should
    page.should have_content('I am a Pro Dog Walker')
  else
    assert page.has_content('I am a Pro Dog Walker')

  end
end

