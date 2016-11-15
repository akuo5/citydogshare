FactoryGirl.define do
  factory :event do
    dogs { [Dog.find(1)] }
    start_date Date.new(2017, 5, 13)
    end_date Date.new(2017, 5, 17)
    location_id 1
    description "need someone to dogsit"
    user_id 1
  end
end