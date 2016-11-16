require 'cucumber/rspec/doubles'
require 'aws-sdk'

Given /^the date is "(\d\d\d\d\/\d\d\/\d\d)"$/ do |date|
  Time.stub(:now).and_return(date)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

Given /the following dogs exist/ do |dogs_table|\
  Dog.any_instance.stub(:geocode)
  s3_client = Aws::S3::Client.new(stub_responses: true)
  allow(Aws::S3::Client).to receive(:new).and_return(s3_client)

  allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  dogs_table.hashes.each do |dog|
    new_dog = Dog.new()
    new_dog.user_id = dog[:user_id]
    new_dog.name = dog[:name]
    new_dog.gender = dog[:gender]
    new_dog.size_id = Size.find_by_value(dog[:size]).id
    new_dog.dob = DateTime.new(Time.now.year - dog[:age].to_i, 3, 3)
    new_dog.mixes << Mix.find_by_value(dog[:mix])
    new_dog.personalities << Personality.find_by_value(dog[:personality])
    new_dog.likes << Like.find_by_value(dog[:likes])
    new_dog.energy_level_id = EnergyLevel.find_by_value(dog[:energy]).id
    new_dog.latitude = dog[:latitude]
    new_dog.longitude = dog[:longitude]
    new_dog.fixed = dog[:fixed]
    new_dog.chipped = dog[:chipped]
    new_dog.availability = dog[:availability]
    new_dog.photo = File.new(Rails.root + 'spec/factories/images/dog.jpg')
    new_dog.save!
  end
end

Given /^I make a request to see all dogs$/ do
  visit path_to("dogs api")
end

Given /^I make a request to see all available dogs$/ do
  visit path_to("available dogs api")
end

When /^(?:|I )do not care about dog location/ do
  Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field, match: :first)
end

When(/^I select "([^"]*)" for "([^"]*)"$/) do |value, id|
  within "##{id}" do
    select(value, match: :first)
  end
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field, match: :first)
end

When /^I create a new dog "([^"]*)"$/ do |name|
  s3_client = Aws::S3::Client.new(stub_responses: true)
  allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
  FactoryGirl.create(:dog)
end

And /^I push "([^"]*)"$/ do |button|
  click_button(button)
end

Given /^my zipcode is "(.*)"$/ do |zip|
  allow_any_instance_of(DogsController).to receive(:get_ip_address_zipcode).and_return(zip)
end

Then /"(.*)" should appear before "(.*)"/ do |first_example, second_example|
  page.body.should =~ /#{first_example}.*#{second_example}/m
end

When /^(?:|I )attach the file "([^\"]*)" to "([^\"]*)"/ do |path, field|
  s3_client = Aws::S3::Client.new(stub_responses: true)
  allow(Aws::S3::Client).to receive(:new).and_return(s3_client)

  allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  attach_file(field, File.expand_path(path))
end

And /^I press Schedule$/ do
  EventViewHelper.any_instance.stub(:get_date).and_return(DateTime.current.to_date)
  click_button("Schedule")
end

And /^I click a star for dog with dog id "(.)"/ do |id|
    click_link("star_#{id}")
end

And /^I should not see a star$/ do
  all('div.stars').count.should == 0
  all('span.stars').count.should == 0
end

When /^(?:|I )follow the dog named "([^"]*)"$/ do |link|
  click_link("About " + link)
end

Then /^I should see (today|yesterday)'s date$/ do |time|
  if time == 'today'
    page.should have_content(DateTime.current.strftime('%v').upcase)
  else
    page.should have_content(DateTime.yesterday.strftime('%v').upcase)
  end
end

Then /^I should not see (today|yesterday)'s date$/ do |time|
  if time == 'today'
    page.should_not have_content(DateTime.current.strftime('%v').upcase)
  else
    page.should_not have_content(DateTime.yesterday.strftime('%v').upcase)
  end
end

When(/^I select "([^"]*)"$/) do |value|
  page.find("option[value='#{value}']").click
end


Given(/^I fill in "([^"]*)" with (today|tomorrow|yesterday)$/) do |field, day|
  case day
  when 'today'
    date = Date.today
  when 'tomorrow'
    date = Date.tomorrow
  when 'yesterday'
    date = Date.yesterday
  else
    date = Date.today
  end
  fill_in(field, :with => date)
end

Then(/^I should see (today|tomorrow)$/) do |day|
  case day
  when 'today'
    date = Date.today.strftime('%b %d, %Y')
  when 'tomorrow'
    date = Date.tomorrow.strftime('%b %d, %Y')
  else
    date = Date.today
  end
  if page.respond_to? :should
    page.should have_content(date)
  else
    assert page.has_content?(date)
  end
end

And /^I have created an event for "([^"]*)" (today|3 days ago)$/ do |dog, time|
  new_event = Event.new()
  if time == "today"
    new_event.start_date = Date.current.to_date
    new_event.end_date = Date.current.to_date
  else
    new_event.start_date = 3.days.ago
    new_event.end_date = 3.days.ago
  end
  new_event.location = Location.find(1)
  new_event.description = "Princess needs a walk"
  new_event.dogs << Dog.find_by_name(dog)
  new_event.user = User.find(1)
  new_event.save!
end
