FactoryGirl.define do
  factory :dog do
    name "Spock"
    gender "Male"
    photo_file_name "fido.jpg"
    dob Time.new(2011, 2, 3)
    mixes { [Mix.find(1)] }
    description ""
    motto "Live long and play fetch."
    fixed false
    chipped false
    health ""
    availability ""
    size { Size.find(1) }
    energy_level { EnergyLevel.find(1) }
    personalities { [Personality.find(1)] }
    user_id { 1 }
    photo File.new(Rails.root + 'spec/factories/images/dog.jpg')
  end
end