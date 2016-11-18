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
  
  it 'should be able to get all attribute values' do
    assert_equal Bark.all_values, ["Rarely", "When playing", "When someone's at the door", "When left alone", "All the time"]
    assert_equal Mix.all_values.count, 488
    assert_equal Size.all_values, ["small (0-15)", "medium (16-40)", "large (41-100)", "xl (101+)"]
    assert_equal Personality.all_values, ["anxious", "curious", "timid", "whatever", "friendly", "fetcher", "lover", "still a puppy"]
    assert_equal EnergyLevel.all_values, ["high", "active", "good", "some", "low", "zzzzz"]
  end

  it 'should correctly show name' do
    assert_equal @dog.name, "Spock"
  end

  it 'should correctly show dogs person' do
    assert_equal @dog.owner, @user
  end

  it 'should correctly show energy level' do
    assert_equal @dog.energy_level, EnergyLevel.find(1)
  end
  
  it 'should correctly show size' do
    assert_equal @dog.size, Size.find(1)
  end
  
  it 'should correctly show readable attributes' do
    assert_equal @dog.readable_mixes, ["Affenpinscher"]
    assert_equal @dog.readable_personalities, ["Anxious"]
    assert_equal @dog.tags, "Anxious"
    assert_equal @dog.readable_size, "Small (0-15)"
    assert_equal @dog.readable_energy_level, "High"
    assert_equal @dog.readable_likes, []
    assert_equal @dog.readable_barks, []
    assert_equal @dog.readable_fixed, "No"
    assert_equal @dog.readable_chipped, "No"
    assert_equal @dog.readable_shots_to_date, "Unknown"
    @dog.shots_to_date = true
    assert_equal @dog.readable_shots_to_date, "Yes"
    assert_equal @dog.readable_fixed, "No"
  end

  it 'should correctly show that there are no future events' do
    expect(@dog.future_events?).to be_falsey
    assert_equal @dog.future_events.count, 0
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
    expect(@dog.tags).to eq("1 and 2")
  end
  
  it 'should return a list of genders' do 
    expect(Dog.genders).to be_a_kind_of(Array)
  end
  
  it 'should return a list of age ranges' do 
    expect(Dog.age_ranges).to be_a_kind_of(Array)
  end
  
  it 'should return a dog as a form-compatible hash' do
    # throw @dog.to_form_hash
    form_hash = @dog.to_form_hash
    expect(form_hash[:name]).to eq("Spock")
    expect(form_hash[:dob]).to eq(2011)
    expect(form_hash[:size]).to eq(1)
    expect(form_hash[:gender]).to eq("Male")
    expect(form_hash[:mixes]).to eq(["Affenpinscher"])
    expect(form_hash[:personalities]).to eq(["anxious"])
    expect(form_hash[:energy_level]).to eq(1)
    expect(form_hash[:fixed]).to eq(false)
    expect(form_hash[:chipped]).to eq(false)
    expect(form_hash[:status]).to eq("Live long and play fetch.")
  end
  
  it 'should return a dog in the correct json format' do
    json_obj = @dog.to_json
    expect(json_obj[:name]).to eq("Spock")
    expect(json_obj[:dob]).to eq(2011)
    expect(json_obj[:size]).to eq("Small (0-15)")
    expect(json_obj[:gender]).to eq("Male")
    expect(json_obj[:mixes]).to eq(["Affenpinscher"])
    expect(json_obj[:personalities]).to eq(["Anxious"])
    expect(json_obj[:energy_level]).to eq("High")
    expect(json_obj[:fixed]).to eq(false)
    expect(json_obj[:chipped]).to eq(false)
    expect(json_obj[:status]).to eq("Live long and play fetch.")
    expect(json_obj[:parent]).to_not eq(nil)
  end
end
