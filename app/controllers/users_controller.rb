class UsersController < ApplicationController
  before_filter :current_user

  def show
    if User.exists?(params[:id]) == false
      flash[:notice] = "The user you entered does not exist."
      redirect_to @current_user
    else
      id = params[:id]
      @own_profile = false
      @user = User.find(id)
      if @user == @current_user
        @own_profile = true
      end
      render 'show'
    end
  end

  def edit
    if User.exists?(params[:id]) == false || User.find(params[:id]) != @current_user
      flash[:notice] = "You may only edit your own profile."
      redirect_to @current_user
    elsif params[:user] != nil and @current_user.update_attributes(user_params)
      @current_user.dogs.each do |dog|
        dog.geocode
        dog.save
      end
      flash[:notice] = "Profile successfully updated."
      redirect_to @current_user
    else
      render 'edit'
    end
  end

  # This destroys the user and signs them out, taking them to the home page
  def destroy
    @current_user.destroy
    session[:user_id] = nil
    redirect_to root_path()
  end

  def stars
    if !@current_user.nil? and @current_user.id != params[:id].to_i
      redirect_to(stars_user_path(@current_user))
    end
    @dogs = User.find_by_id(params[:id]).starred_dogs
  end
  
  def dogs
    if !@current_user.nil? and @current_user.id != params[:id].to_i
      redirect_to(dogs_user_path(@current_user))
    end
    # byebug
    @dogs = User.find_by_id(params[:id]).dogs
  end

  private
  def user_params
    if params[:user]
      params.require(:user).permit(:first_name, :last_name, :location, :gender, :image, :status, :phone_number, :email, :availability, :description, :address, :zipcode, :city, :country)
    end
  end
end
