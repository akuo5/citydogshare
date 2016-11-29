require 'rails_helper'

RSpec.describe Admin, type: :model do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  it "should be return false if no user is inputted" do
    expect(Admin.is_admin?(nil)).to eq(false)
  end
  
  it "should return true if a non-admin user is inputted" do
    Admin.stub_chain(:where, :exists?).and_return(false)
    expect(Admin.is_admin?(@user)).to eq(false)
  end
  
  it "should return true if an admin user is inputted" do
    Admin.stub_chain(:where, :exists?).and_return(true)
    expect(Admin.is_admin?(@user)).to eq(true)
  end
  
end
