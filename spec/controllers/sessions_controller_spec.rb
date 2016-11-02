require 'rails_helper'

describe SessionsController, :type => :controller do
  include Capybara::DSL

  describe 'create new session' do
    before(:each) do
      @user = User.create(:id => "1")
      @user.uid = "12345" 
      @user.save
    end
    it 'should set the user id in the session hash' do
      get(:create, :user => "1")
      assert_equal "12345", session[:user_id]
    end
    it 'should redirect to the user profile page' do
      get(:create, :user => "1")
      expect(response).to redirect_to user_path(:id => "1")
    end
  end
  
  describe 'destroy current session (signout)' do
    before(:each) do
      session[:user_id] = "12345"
    end
    it 'should nullify the user id in the session hash' do
      get(:destroy)
      assert_equal session[:user_id], nil
    end
    it 'should redirect to the home page' do
      get(:destroy)
      expect(response).to redirect_to root_path()
    end
  end 

  describe 'handle_auth' do
    it 'should find the user' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      expect(User).to receive(:find_by_uid).with(request.env["omniauth.auth"][:uid])
      visit "auth/facebook?type=login"
    end 
    it 'should redirect to signup if signing up' do 
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      request.env["omniauth.params"] = {"type" => "signup"}
      User.stub(:find_by_uid).and_return(User.create(:id => "1", :first_name => "M", :last_name => "J"))
      get(:handle_auth, :provider => "facebook")
      expect(response).to redirect_to signup_path(:user => "1", :auth => request.env["omniauth.auth"])
    end
    it 'should redirect to login if logging in' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      request.env["omniauth.params"] = {"type" => "login"}
      User.stub(:find_by_uid).and_return(User.create(:id => "1", :first_name => "M", :last_name => "J"))
      get(:handle_auth, :provider => "facebook")
      expect(response).to redirect_to login_path(:user => "1", :credentials => request.env["omniauth.auth"][:credentials])
    end
  end

  describe 'logging in as an existing user' do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      @user1 = User.create()
      @user1.uid = "12345"
    end
    it 'should redirect to the user profile page' do 
      get(:login, :user => @user1, :credentials => request.env["omniauth.auth"][:credentials])
      expect(response).to redirect_to create_session_path(:user => "1")
    end

  end

  describe 'logging in as a new user' do
    it 'should redirect to the home page with error message' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      get(:login, :user => nil, :credentials => request.env["omniauth.auth"][:credentials])
      expect(response).to redirect_to root_path() 
      assert_equal "User does not exist. Please sign up.", flash[:notice]
    end
  end

  describe 'authentication fails' do 
    it 'should redirect to the home page with error message' do
      get(:handle_failure)
      assert_equal "Something went wrong with the authentication. Please try again.", flash[:notice]
      expect(response).to redirect_to root_path()

    end
  end
  


  describe 'signing up as an existing user' do
    it 'should redirect to the home page with error message' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
      User.create()
      get(:signup, :user => "1" , :auth => request.env["omniauth.auth"])
      assert_equal "A user already exists with this facebook account.", flash[:notice]
      expect(response).to redirect_to root_path() 
    end 
  end

  describe 'signing up a new user' do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
    end
    it 'should create a new user' do
      get(:signup, :user => nil , :auth => request.env["omniauth.auth"])
      expect(assigns(:new_user)).to be_an_instance_of(User)
    end
    it 'should update their credentials' do
      expect_any_instance_of(User).to receive(:update_credentials)
      get(:signup, :user => nil , :auth => request.env["omniauth.auth"])
    end
    it 'should set their facebook info' do
      expect_any_instance_of(User).to receive(:facebook_info_update)
      get(:signup, :user => nil , :auth => request.env["omniauth.auth"])
    end
    it 'should redirect to create a new session' do
      get(:signup, :user => nil , :auth => request.env["omniauth.auth"])
      expect(response).to redirect_to create_session_path(:user => "1")
    end
  end
  
  
  
  
  
#   #Tests 10/19/16
# #   RSpec.configure do |config|
# #   config.include FacebookMacros
# # end



# #:first_name, :last_name, :location, :gender, :image, :status, :phone_number, :email, :availability, :description, :address, :zipcode, :city, :country
    
#   describe 'login to facebook' do
#     before :each do
#     # Capybara.default_wait_time = 10
#     # Capybara.app_host = 'http://' + Settings.host
#     @user = User.create(:first_name => "Ruth", :last_name => "Shepardsky", :email => "ruth_nejcocw_shepardsky@tfbnw.net")
#     @user.uid = "122233108246861" 
#     @user.save
    
#     end
    
#     it 'should create a new user' do
#       get(:signup, :user => nil , :auth => request.env["omniauth.auth"])
#       expect(assigns(:new_user)).to be_an_instance_of(User)
#     end
    
#     it 'should authenticate with facebook login' do
#       get(:login, :user => @user , :auth => request.env["omniauth.auth"])
#       # complete_facebook_dialogues_on_click('#log_in', @user)
#       expect(response).to redirect_to create_session_path(:user => "1")
#   end
# end

    
end
    
