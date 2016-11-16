require 'rails_helper'

describe DogsController, :type => :controller do
  include Capybara::DSL
  before(:each) do
    
    s3_client = Aws::S3::Client.new(stub_responses: true)
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    @user = FactoryGirl.create(:user)
    Dog.any_instance.stub(:geocode)
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  end

  describe 'searching/viewing dogs' do
    it 'should display all dogs given big radius' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      dogs = [dog1, dog2]
      params = {}
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
    it 'should filter by gender' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :gender => "Female")
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      dogs = [dog2]
      params = {}
      params[:gender] = ["Female"]

      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
    it 'should filter by age' do
      Time.stub(:now).and_return(Time.mktime(2014,1))
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :dob => Time.new(2013, 2))
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      dogs = [dog2]
      params = {}
      params[:age] = ["0"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should filter by mix' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      dog2.mixes << Mix.find_by_value("Labrador")
      dog2.save!
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      dogs = [dog2]
      params = {}
      params[:mix] = ["Labrador"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
    
    it 'should filter by personality' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      dog2.personalities << Personality.find_by_value("friendly")
      dog2.save
      dogs = [dog2]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:personality] = ["friendly"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should filter by likes' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      dog2.likes << Like.find_by_value("cats")
      dog2.save
      dogs = [dog2]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:like] = ["cats"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
   
    it 'should filter by energy level' do
      dog1 = FactoryGirl.create(:dog, :energy_level_id => 2)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      dogs = [dog2]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:energy_level] = ["high"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should filter by size' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      dogs = [dog1]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:size] = ["small (0-15)"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should handle multiple criteria' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      dogs = [dog1]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:gender] = ["Male"]
      params[:size] = ["small (0-15)"]
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
  
    it 'should report when no results match criteria' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:size] = ["xl(101+)"]
      get :index, params
      expect(assigns(:no_dogs)).to eq(true)
    end
  end


  describe 'render new dog page' do
  before(:each) do
    session[:user_id] = "12345"
    Dog.any_instance.stub(:geocode)
    @dog = FactoryGirl.create(:dog)

  end
    it "should render the form" do
      get :new
      expect(response).to render_template('new')
    end

    it 'should redirect to edit user page if no user address' do
      @user.zipcode = ""
      @user.save
      get :new
      response.should redirect_to edit_user_path(@user)
    end
  end

  describe 'create a new dog' do 
  before(:each) do
    @current_user = User.find_by_id(1)
    session[:user_id] = "12345"
    Dog.any_instance.stub(:geocode)
    @dog = FactoryGirl.create(:dog)
    @params = {  "dog"=>{"name"=>"Lab", "dob(1i)"=>"2010", "dob(2i)"=>"4", "dob(3i)"=>"4", "gender"=>"Male",
                  "size"=>"1", "motto"=>"Hi", "description"=>"", "energy_level"=>"1", "health"=>"", "fixed"=>"true",
                  "availability"=>"", "mixes" =>["Australian Shepherd"], "personalities"=>{"curious"=>"1"},
                  "likes"=>{"dogs (some or most)"=>"1", "men"=>"1"}}, "update_dog_button"=>"Save Changes"}
    end

    it 'should call attributes_list' do
      Dog.any_instance.stub(:valid?).and_return(true) 
      controller.stub(:current_user).and_return(@current_user)
      post :create, @params
      response.should redirect_to dogs_user_path(@current_user)
    end

    it 'should redirect with bad params' do
      @params['dog']['name'] = ""
      controller.stub(:current_user).and_return(@current_user)
      post :create, @params
      response.should render_template 'new'
    end

  end

  describe 'should show the correct dog profile' do
  before(:each) do
    Dog.any_instance.stub(:geocode)
    @dog = FactoryGirl.create(:dog)
    @current_user = User.create()
  end
    it 'render the html' do
      get :show, {:id => @dog.id}
      expect(response).to render_template('show')
    end
  end

  describe 'dog edit' do
    before(:each) do
      Dog.any_instance.stub(:geocode)
      @dog = FactoryGirl.create(:dog)
      @current_user = User.create()
    end
    it 'should update dog' do 
      get :edit, {:id => @dog.id}
      expect(controller.instance_variable_get(:@dog)).to eql(@dog)
      expect(controller.instance_variable_get(:@action)).to eql(:update)
      expect(controller.instance_variable_get(:@method)).to eql(:put)
    end
  end

  describe 'dog update' do
    before(:each) do
      Dog.any_instance.stub(:geocode)
      @dog = FactoryGirl.create(:dog)
      @current_user = User.new(:id => 1, :uid => "12345")
      @params = {  "id" => @dog.id, "dog"=>{"name"=>"Lab", "dob(1i)"=>"2010", "dob(2i)"=>"4", "dob(3i)"=>"4", "gender"=>"Male",
                  "size"=>"1", "motto"=>"Hi", "description"=>"", "energy_level"=>"1", "health"=>"", "fixed"=>"true",
                  "availability"=>"", "mixes" =>["Australian Shepherd"], "personalities"=>["curious"],
                  "likes"=>{"dogs (some or most)"=>"1", "men"=>"1"}}, "update_dog_button"=>"Save Changes"}
      @session = { "user_id" => @current_user.uid }
    end

    it 'redirect to dog profile if noerrors' do 
      get :update, @params, @session
      expect(controller.instance_variable_get(:@dog)).to eql(@dog)
      response.should redirect_to "/users/1/dogs"
    end
    
    it 'should redirect to edit if errors' do
      @params["dog"]["name"] = ""
      get :update, @params
      redirect_to edit_dog_path("1")
    end
  end

  describe 'incorrect dog update' do
    before(:each) do
      Dog.any_instance.stub(:geocode)
      @dog = FactoryGirl.create(:dog)
      @current_user = User.new(:id => 1, :uid => "12345")
      @params = { "id" => @dog.id, "dog"=>{"name"=>"Lab", "dob(1i)"=>"2010", "dob(2i)"=>"4", "dob(3i)"=>"4", "gender"=>"Male",
                  "size"=>"1", "motto"=>"Hi", "description"=>"", "energy_level"=>"1", "health"=>"", "fixed"=>"true",
                  "availability"=>"", "mixes" =>["Australian Shepherd", "Tabby"], "personalities"=> ["curious", "yellow"],
                  "likes"=>{"dogs (some or most)"=>"1", "men"=>"1", "you!"=>"1"}}, "update_dog_button"=>"Save Changes"}
      @session = { "user_id" => @current_user.uid }
    end

    it 'should not update a dog to include params that do not exist' do 
      get :update, @params, @session
      expect(controller.instance_variable_get(:@dog)).to eql(@dog)
      response.should redirect_to "/users/1/dogs"
    end
  end

  describe 'delete dog' do
    before(:each) do
      Dog.any_instance.stub(:geocode)
      @dog = FactoryGirl.create(:dog)
      @current_user = User.create()
    end
    it 'should delete dog and if user owns dog' do
      controller.instance_variable_set(:@current_user, @user)
      get(:destroy, :id => @dog.id)
      expect(controller.instance_variable_get(:@dog)).to eql(@dog)
      assert_equal Dog.all, []
    end
  end

  describe 'test edit' do
    before(:each) do
      @dog = FactoryGirl.create(:dog)
      @current_user = User.create(:id => 1)
    end
  end
  
  describe 'makes a call to the api to get a single dogs info' do
    before(:each) do
      @params = { :id => 1 }
      @dog = FactoryGirl.create(:dog)
      Dog.stub(:find).and_return(@dog)
      @dog.stub(:to_json).and_return(0)
    end
    it 'should show an error when the dog does not exist' do
      @expected = { "success" => false, "message" => "Dog not found" }.to_json
      Dog.stub(:exists?).and_return(false)
      get :info, @params
      response.body.should == @expected
    end
    it 'should show info when the dog does exist' do
      @expected = { 
        "success" => true, 
        "message" => "Dog found", 
        "dog" => 0
      }.to_json
      Dog.stub(:exists?).and_return(true)
      get :info, @params
      response.body.should == @expected
    end
  end

  describe 'makes a call to the api to get multiple dogs info' do
    before(:each) do
      @dog = FactoryGirl.create(:dog)
      Dog.stub(:all).and_return([@dog])
    end
    it 'shows all dogs if no params are set' do
      @expected = { 
        "success" => true, 
        "message" => "1 dog(s) found", 
        "dogs" => [{ :name => "Spock", :id => 1 }]
      }.to_json
      get :all_info, {}
      response.body.should == @expected
    end
    it 'shows available dog if the available param is set to true and the dog is available' do
      @expected = { 
        "success" => true, 
        "message" => "1 dog(s) found", 
        "dogs" => [{ :name => "Spock", :id => 1 }]
      }.to_json
      @dog.stub(:available).and_return(true)
      get :all_info, { :available => "true" }
      response.body.should == @expected
    end
    it 'doesnt show available dog if the available param is set to true and the dog isnt available' do
      @expected = { 
        "success" => true, 
        "message" => "0 dog(s) found", 
        "dogs" => []
      }.to_json
      @dog.stub(:available).and_return(false)
      get :all_info, { :available => "true" }
      response.body.should == @expected
    end
    it 'doesnt show available dog if the available param is set to false' do
      @expected = { 
        "success" => true, 
        "message" => "0 dog(s) found", 
        "dogs" => []
      }.to_json
      @dog.stub(:available).and_return(true)
      get :all_info, { :available => "false" }
      response.body.should == @expected
    end
    it 'shows unavailable dog if the available param is set to false' do
      @expected = { 
        "success" => true, 
        "message" => "1 dog(s) found",
        "dogs" => [{ :name => "Spock", :id => 1 }]
      }.to_json
      @dog.stub(:available).and_return(false)
      get :all_info, { :available => "false" }
      response.body.should == @expected
    end
  end

end
