require 'rails_helper'

describe StarredDogsController, :type => :controller do
  include Capybara::DSL
  before(:each) do
    s3_client = Aws::S3::Client.new(stub_responses: true)
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    
    @current_user = FactoryGirl.create(:user)
    request.env["HTTP_REFERER"] = "back"
    
    @params = { :dog_id => 0}
    @dog = FactoryGirl.create(:dog)
    allow(Dog).to receive(:find).and_return(@dog)
    allow(@dog).to receive(:id).and_return(0)
    
    allow(controller).to receive(:current_user).and_return(@current_user)
  end
  
  describe "Create a new star" do
    it "should create a new star and redirect back" do
      @dog = FactoryGirl.create(:dog)
      expect(Star).to receive(:create).and_return(true)
      post :create, @params
      response.should redirect_to "back"
    end
  end
  
  describe "Remove a new star" do
    it "should destroy a star and go back" do
      Star.stub_chain(:where, :first, :destroy).and_return(true)
      allow_any_instance_of(Dog).to receive(:id).and_return(0)
      get :destroy, @params
      response.should redirect_to "back"
    end
  end
  
end