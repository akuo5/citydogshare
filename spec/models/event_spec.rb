require 'rails_helper'

describe Event do
  before(:each) do
      @event = Event.create(:id => "1")
      @event.dog_id = "1" 
      @event.save
  end
  it 'should return the correct color' do
    assert_equal @event.color, "orange"
    assert_equal @event.text_color, "black"
  end
end