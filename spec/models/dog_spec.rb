require 'rails_helper'

describe Dog do
  before(:each) do
      Time.stub(:now).and_return(Time.mktime(2014,1))
      s3_client = Aws::S3::Client.new(stub_responses: true)
      allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
      @user = FactoryGirl.create(:user)
      @dog = FactoryGirl.create(:dog)

  end


  it 'should correctly show name' do
    assert_equal @dog.name, "Spock"
  end

  it 'should not save an invalid date of birth' do
    @dog.dob = DateTime.parse("3/2017")
    @dog.valid?
    @dog.errors.should have_key(:dob)
  end

  it 'should calculate age correctly if under 1 year old' do
    @dog.dob = DateTime.parse('3/2013')
    @dog.save
    assert_equal @dog.age, 0
  end

  it 'should calculate age correctly if over 1 year old' do
    @dog.dob = DateTime.parse('3/2011')
    @dog.save
    assert_equal @dog.age, 2
  end

  it 'should not save profile with unfilled name' do
    @dog.name = nil
    @dog.save
    @dog.errors.should have_key(:name)
  end

  it 'should not save profile with empty mix' do
    @dog.mixes = []
    @dog.save
    @dog.errors.should have_key(:mixes)
  end

  it 'should parse simple youtube URL correctly' do
    @dog.video = "https://www.youtube.com/watch?v=to0JYZJxXOc"
    @dog.save
    expect(@dog.youtube_id).to eq("to0JYZJxXOc")
  end

  it 'should parse youtube URL with & correctly' do
    @dog.video = "https://www.youtube.com/watch?v=to0JYZJxXOc&something"
    @dog.save
    expect(@dog.youtube_id).to eq("to0JYZJxXOc")
  end
  
  it 'should give a correct age caption' do
    @dog.dob = DateTime.parse('3/2013')
    expect(@dog.age_caption).to eq("< 1 year old")
    @dog.dob = DateTime.parse('3/2012')
    expect(@dog.age_caption).to eq("1 year old")
    @dog.dob = DateTime.parse('3/2011')
    expect(@dog.age_caption).to eq("2 years old")
  end
  
  it 'should correctly output the dogs tags' do
    expect(@dog).to receive(:readable_personalities).and_return(["1", "2"])
    expect(@dog.tags).to eq("1, 2")
  end
  
  it 'shuld return a list of genders' do 
    expect(Dog.genders).to be_a_kind_of(Array)
  end
  
  it 'shuld return a list of age ranges' do 
    expect(Dog.age_ranges).to be_a_kind_of(Array)
  end
end
