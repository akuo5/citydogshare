require 'rails_helper'

describe Event do
  before(:each) do
    s3_client = Aws::S3::Client.new(stub_responses: true)
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
    @user = FactoryGirl.create(:user)
    @dog = FactoryGirl.create(:dog)
    @event = FactoryGirl.create(:event)
  end
  it 'should return a readable list of dogs' do
    assert_equal @event.readable_dogs, "Spock"
  end
  it 'should return a correct form hash' do
    hash = {:start_date=> Date.today, 
      :end_date=>Date.tomorrow, :location_id=>"1", :dogs=>[1], 
      :description=>"need someone to dogsit"}
    assert_equal @event.to_form_hash, hash
  end
end