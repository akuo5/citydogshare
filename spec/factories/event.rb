FactoryGirl.define do
  factory :event do
    dogs { [Dog.find(1)] }
    start_date Date.today
    end_date Date.tomorrow
    location_id 1
    description "need someone to dogsit"
    user_id 1
  end
end