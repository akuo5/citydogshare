# require 'rails_helper'

# describe DogsController, :type => :controller do
#   include Capybara::DSL
#   before(:each) do
    
#     s3_client = Aws::S3::Client.new(stub_responses: true)
#     allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
#     @user = FactoryGirl.create(:user)
#     Dog.any_instance.stub(:geocode)
#     allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
#   end

#   describe 'searching/viewing dogs' do
#     it 'should display all dogs given big radius' do
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       dogs = [dog1, dog2]
#       params = {}
#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end
#     it 'should filter by gender' do
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :gender => "Female")
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       dogs = [dog2]
#       params = {}
#       params[:gender] = {"Female" => 1}

#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end
#     it 'should filter by age' do
#       Time.stub(:now).and_return(Time.mktime(2014,1))
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :dob => Time.new(2013, 2))
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       dogs = [dog2]
#       params = {}
#       params[:age] = {"0" => 1}
#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end

#     it 'should filter by mix' do
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
#       dog2.mixes << Mix.find_by_value("Labrador")
#       dog2.save!
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       dogs = [dog2]
#       params = {}
#       params[:mix] = "Labrador"
#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end
    
#     it 'should filter by personality' do
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
#       dog2.personalities << Personality.find_by_value("friendly")
#       dog2.save
#       dogs = [dog2]
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       params = {}
#       params[:personality] = {"friendly" => 1}
#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end

#     it 'should filter by likes' do
#       dog1 = FactoryGirl.create(:dog)
#       dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
#       dog2.likes << Like.find_by_value("cats")
#       dog2.save
#       dogs = [dog2]
#       Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
#       params = {}
#       params[:like] = {"cats" => 1}
#       get :index, params
#       expect(assigns(:dogs)).to match_array(dogs)
#     end
   
    it 'should filter by energy level' do
      dog1 = FactoryGirl.create(:dog, :energy_level_id => 2)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy")
      dogs = [dog2]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:energy_level] = {"high" => 1}
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should filter by size' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      dogs = [dog1]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:size] = {"small (0-15)" => 1}
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end

    it 'should handle multiple criteria' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      dogs = [dog1]
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:gender] = {"Male" => 1}
      params[:size] = {"small (0-15)" => 1}
      get :index, params
      expect(assigns(:dogs)).to match_array(dogs)
    end
  
    it 'should report when no results match criteria' do
      dog1 = FactoryGirl.create(:dog)
      dog2 = FactoryGirl.create(:dog, :name => "Fluffy", :size_id => 2)
      Dog.stub(:near).and_return(Dog.where(:gender => ["Male", "Female"]))
      params = {}
      params[:size] = {"xl(101+)" => 1}
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
      response.should redirect_to user_path(@current_user)
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
      @current_user = User.create()
      @params = {  "id" => @dog.id, "dog"=>{"name"=>"Lab", "dob(1i)"=>"2010", "dob(2i)"=>"4", "dob(3i)"=>"4", "gender"=>"Male",
                  "size"=>"1", "motto"=>"Hi", "description"=>"", "energy_level"=>"1", "health"=>"", "fixed"=>"true",
                  "availability"=>"", "mixes" =>["Australian Shepherd"], "personalities"=>{"curious"=>"1"},
                  "likes"=>{"dogs (some or most)"=>"1", "men"=>"1"}}, "update_dog_button"=>"Save Changes"}
    end
    it 'redirect to dog profile if noerrors' do 
      # byebug
      get :update, @params
      expect(controller.instance_variable_get(:@dog)).to eql(@dog)
      response.should redirect_to dog_path("1")
    end
    it 'should redirect to edit if errors' do
      @params["dog"]["name"] = ""
      get :update, @params
      redirect_to edit_dog_path("1")
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


end
