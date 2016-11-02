class DogsController < ApplicationController

  require 'dog_form_filler'

  before_filter :current_user

  def index
    ip_zipcode = get_ip_address_zipcode
    @form_filler = DogViewHelper.new(current_user, ip_zipcode, true)
    @form_filler.update_values(params, ip_zipcode, current_user)
    @dogs = Dog.filter_by @form_filler.values
    @no_dogs = @dogs.empty?

    @zipcodes = get_zipcode_from_dogs
    @counts = get_zipcode_counts.to_json
  end

  def get_ip_address_zipcode
    # request.safe_location.postal_code
    '94704'
  end

  def new
    @form_filler = DogViewHelper.new(nil, nil, false)
    @action = :create
    @method = :post

    unless current_user.zipcode != nil and current_user.zipcode != "" 
      flash[:notice] = "Please update your zipcode to add a dog."
      redirect_to edit_user_path(current_user)
    end
  end


  def show
    id = params[:id]
    @dog = Dog.find(id)
    @parent = User.find(@dog.user_id)
    @pictures = @dog.pictures
  end

  def create
    @form_filler = DogViewHelper.new(nil, nil, false)
    @dog = Dog.new(@form_filler.attributes_list(dog_params))
    @dog.user_id = current_user.id
    if @dog.save      
      add_multiple_pictures(@dog)
      redirect_to user_path(current_user)
    else
      flash[:notice] = @dog.errors.messages
      render 'new'
    end
  end

  def edit
    @form_filler = DogViewHelper.new(nil, nil, false)
    @dog = Dog.find(params[:id])
    @pictures = @dog.pictures
    @form_filler.dog_view_update(@dog)
    @action = :update
    @method = :put
  end

  def update
    @form_filler = DogViewHelper.new(nil, nil, false)
    @dog = Dog.find(params[:id])
    @pictures = @dog.pictures
    if @dog.update_attributes(@form_filler.attributes_list(dog_params))
      delete_checked_pictures        
      add_multiple_pictures(@dog)
      redirect_to dog_path(@dog.id)
    else
      flash[:notice] = @dog.errors.messages
      redirect_to edit_dog_path(@dog.id) 
    end
  end

  def destroy
    @dog = Dog.find(params[:id])
    @dog.photo.destroy
    @dog.delete
    redirect_to user_path(@current_user)
  end

  def get_zipcode_from_dogs
    @dogs.all.collect{|dog| dog.address}
  end

  def get_zipcode_counts
    wf = Hash.new(0)
    @zipcodes.each{|word| wf[word] += 1}
    wf
  end

  def dog_params
    params.require(:dog).keys.each do |key|
      if params[:dog][key].kind_of?(Array)
        params[:dog][key] = purge_param(params[:dog][key])
      end
    end
    params.require(:dog).permit(:name, :image, :dob, :gender, :description, 
    :motto, :fixed, :health, :comments, :contact, :availability, {:mixes => []}, 
    {:likes =>[]}, :energy_level, :size, :photo, :latitude, :longitude, :video, 
    :dob, {:personalities =>[]}, :chipped, :shots_to_date, {:barks => []})
  end
  
  def purge_param(param)
    param.each do |val|
      unless Mix.all_values.include?(val) or Personality.all_values.include?(val) or Like.all_values.include?(val) then
        param.delete(val)
      end
    end
  end

  def add_multiple_pictures(myDog)
    if params[:images]        
      params[:images].each { |image|
        myDog.pictures.create(image: image)
      }
    end
  end

  def delete_checked_pictures
    activated_ids = params[:activated].collect {|id| id.to_i} if params[:activated]
    seen_ids = params[:seen].collect {|id| id.to_i} if params[:seen]

    if activated_ids
      seen_ids.each do |id|          
        checked = activated_ids.include?(id)
        pic = Picture.find_by_id(id)
        pic.destroy if checked
      end
    end  
  end
end
