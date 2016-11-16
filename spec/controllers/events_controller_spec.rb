require 'rails_helper'

describe EventsController, :type => :controller do
  include Capybara::DSL
  before(:each) do
    session[:user_id] = "12345"
    s3_client = Aws::S3::Client.new(stub_responses: true)
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    @current_user = FactoryGirl.create(:user)
    Dog.any_instance.stub(:geocode)
    @dog = FactoryGirl.create(:dog)
    @event = FactoryGirl.create(:event)
  end

  describe 'render the events page' do
    it 'should render the form' do
      get :new
      expect(response).to render_template('new')
    end

    it 'should redirect if no dogs' do
      @dog.delete
      get :new
      response.should redirect_to dogs_user_path(@current_user.id)
    end
  end

  describe 'create a new user event' do
    before (:each) do 
      @params = {"event" => {"dogs"=>["", "1"], "location"=>"1", 
        "start_date"=>Date.today, "end_date"=>Date.tomorrow,
        "description"=>"abcdefg"}}
      @session = { "user_id" => @current_user.uid }
    end

    it 'should redirect with correct info' do
      post :create, @params, @session
      response.should redirect_to events_path
    end

    it 'should render new with incorrect params' do
      @params["event"]["dogs"] = {}
      post :create, @params, @session
      response.should render_template 'new'
    end
  end

  # Pretty sure these are the form_filler tests
  # describe 'check other methods' do
  #   before (:each) do
      
  #     @params = {"dogs"=>{"Spock"=>"1"}, "date_timepicker"=>{"start"=>"2015/04/17", "end"=>"2015/04/24"}, 
  #     "times"=>{"Morning"=>"1"}, "location"=>"My House", "description" => "", "update_dog_button"=>"Schedule", 
  #     "method"=>"post", "action"=>"create", "controller"=>"events"}
  #     @event = Event.new()
  #   end

  #   it 'should return the hash' do
  #     @form_filler.event_info(@params).should == {:start_date => Date.new(2015, 4, 17), :end_date => Date.new(2015, 4, 24),
  #       :time_of_day => ["Morning"], :location => "My House", :description => ""}
  #   end

  #   it 'should return stuff when empty' do
  #     @params = {"date_timepicker"=>{"start"=>"", "end"=>""}, "location"=>"My House", "description" => ""}
  #     @form_filler.event_info(@params).should == {:start_date => "", :end_date => "", :time_of_day => [], :location => "My House", :description=> ""}
  #   end

  #   it 'should set the flash if dogs is empty' do
  #     controller.instance_variable_set(:@dogs, [])
  #     controller.set_flash
  #     expect(flash[:notice]).to eq({:name => ["Please select a dog to share"]})
  #   end

  #   it 'should return false if event is invalid' do
  #     controller.instance_variable_set(:@dogs, [Dog.find_by_name("Spock")])
  #     controller.instance_variable_set(:@event_attr, {:start_date => "", :end_date => Date.new(2015, 4, 24),
  #       :time_of_day => ["Morning"], :location => "My House", :description => ""})
  #     controller.create_events.should == false
  #   end
  # end

  describe 'show dog events' do

    it 'should get the correct dog' do
      get :index
      assigns(:dog) == Dog.find(1)
    end

    it 'should have the correct user' do
      get :index
      assigns(:current_user).should == @current_user
    end

    it 'should get the right event on show' do
      get :show, {:id => 1}
      assigns(:event).should == @event
    end
  end

  describe 'edit dog events' do
    it 'should find the right event' do
      get :edit, {:id => 1}
      expect(controller.instance_variable_get(:@event_form_values)).to eql(@event.to_form_hash)
      expect(controller.instance_variable_get(:@action)).to eql(:update)
      expect(controller.instance_variable_get(:@method)).to eql(:put)
    end
  end


  describe 'update event' do
    before (:each) do
      @params = {"id" => 1, "event" => {"dogs"=>["", "1"], "location"=>"2", 
        "start_date"=>Date.today, "end_date"=>Date.tomorrow,
        "description"=>"efghijk"}}
    end

    it 'should redirect with good inputs' do
      get :update, @params, @session
      expect(controller.instance_variable_get(:@event)).to eql(@event)
      response.should redirect_to events_path
    end

    it 'should redirect back to edit if bad' do
      @params["event"]["dogs"] = {}
      get :update, @params, @session
      response.should redirect_to edit_event_path('1')
    end

    #it 'should change the event info' do

  end

  describe 'delete event' do
    it 'should delete the event' do
      get :destroy, :id => "1"
      expect(controller.instance_variable_get(:@event)).to eql(@event)
      assert_equal Event.all, []
    end
  end
end



