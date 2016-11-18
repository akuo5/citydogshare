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

  describe 'show dog events' do
    before(:each) do
      @event = FactoryGirl.create(:event)
    end
    
    it 'should get the correct dog' do
      get :index
      assigns(:dog) == Dog.find(1)
    end

    it 'should have the correct user' do
      get :index
      assigns(:current_user).should == @current_user
    end

    it 'should redirect to events page on show' do
      get :show, {:id => 1}
      response.should redirect_to events_path
    end
  end

  describe 'edit dog events' do
    before(:each) do
      @event = FactoryGirl.create(:event)
    end
    it 'should find the right event' do
      get :edit, {:id => 1}
      expect(controller.instance_variable_get(:@event_form_values)).to eql(@event.to_form_hash)
      expect(controller.instance_variable_get(:@action)).to eql(:update)
      expect(controller.instance_variable_get(:@method)).to eql(:put)
    end
  end

  describe 'update event' do
    before(:each) do
      @event = FactoryGirl.create(:event)
    end
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
    before(:each) do
      @event = FactoryGirl.create(:event)
    end
    it 'should delete the event' do
      get :destroy, :id => "1"
      expect(controller.instance_variable_get(:@event)).to eql(@event)
      assert_equal Event.all, []
    end
  end
  
  describe 'help with fc calendar' do
    before(:each) do
      @event = FactoryGirl.create(:event)
      @session = { "user_id" => @current_user.uid }
      @params = { "id" => @event.id, "fc_update" => true, "event" => 
        {"dogs"=>["", "1"], "location"=>"2", "start_date"=>Date.today, 
        "end_date"=>Date.tomorrow, "description"=>"efghijk"}}
    end

    it 'should display the proper json form when prompted by fc cal' do
      get :fc_info, @params, @session
      expect(controller.response_body).to eql([JSON.generate([@event.to_fc_json])])
    end
  end
end



