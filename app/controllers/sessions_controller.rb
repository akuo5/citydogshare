class SessionsController < ApplicationController

  # before_filter :session_expires
  MAX_SESSION_TIME = 60

  # def session_expires
  #     now_time = Time.now
  #     puts session[:expires_at]
  #     exp_time = session[:expires_at]
      
      
  #     minutes_elapsed = (exp_time - now_time)/1.minute
  #     session[:expires_at] = MAX_SESSION_TIME.minutes.from_now
  #     if minutes_elapsed > MAX_SESSION_TIME
  #       return true
  #     else
  #       return false
  #     end
  # end
  
  
  def create 
    @user = User.find(params[:user])
    session[:user_id] = @user.uid
    redirect_to user_path(@user)
  end

  
  # This only destroys the session, equivalent to signing out

  def destroy
    session[:user_id] = nil
    redirect_to root_path()
  end
  
  
  def signout
    session[:user_id] = nil
    redirect_to root_path()
  end 

  def handle_failure
    flash[:notice] = "Something went wrong with the authentication. Please try again."
    redirect_to root_path()
  end

  def login
    # session[:expires_at] = MAX_SESSION_TIME.minutes.from_now
    # if params[:user]
    #   #re-authentication factor
    #   if self.session_expires
    #     #redirect to reauthenticate
    #     redirect_to '/users/auth/facebook?auth_type=reauthenticate'
    #   else
    #     @user = User.find(params[:user])
    #     @user.update_credentials(params[:credentials])
    #     redirect_to create_session_path(:user => @user)
    #   end
    
    if params[:user]
        @user = User.find(params[:user])
        @user.update_credentials(params[:credentials])
        redirect_to create_session_path(:user => @user)

    else
      # @new_user = User.create()
      # @new_user.update_credentials(params[:auth][:credentials])
      # @new_user.facebook_info_update(params[:auth])
      # redirect_to create_session_path(:user => @new_user)
      handle_failure()
    end   
  end 
  
  def signup
    if params[:user]
      if User.exists?(id: params[:user_id])
      #change it to check if the user exists in database
          flash[:notice] = "User already exists. Please log in"
          redirect_to root_path()
      else
        @new_user = User.create()
        @new_user.update_credentials(params[:auth][:credentials])
        @new_user.facebook_info_update(params[:auth])
        redirect_to create_session_path(:user => @new_user)
      end
    else
      @new_user = User.create()
      @new_user.update_credentials(params[:auth][:credentials])
      @new_user.facebook_info_update(params[:auth])
      redirect_to create_session_path(:user => @new_user)
    end
      
  end 
  
  def handle_auth 
    uid = request.env["omniauth.auth"][:uid]
    @user = User.find_by_uid(uid)

    redirect_to login_path(:user => @user, :auth => request.env["omniauth.auth"], :credentials => request.env["omniauth.auth"][:credentials])
  end
 
 
 
 
end