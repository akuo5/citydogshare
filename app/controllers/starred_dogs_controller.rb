class StarredDogsController < ApplicationController
  before_filter :set_dog
  
  def create
    if Star.create(dog: @dog, user: current_user)
      if !request.xhr?
        redirect_to :back
      else
        render :text => "success"
      end
    else
      flash[:notice] = "An error occured when trying to favorite this dog, please try again."
      redirect_to :back
    end
  end
  
  def destroy
    star_to_remove = Star.where(dog_id: @dog.id, user_id: current_user.id).first
    if star_to_remove && star_to_remove.destroy
      if !request.xhr?
        redirect_to :back
      else
        render :text => "success"
      end
    else
      flash[:notice] = "An error occured when trying to unfavorite this dog, please try again."
      redirect_to :back
    end
  end
  
  private
  
  def set_dog
    @dog = Dog.find(params[:dog_id])
  end
end