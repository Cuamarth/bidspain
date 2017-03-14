class SessionsController < ApplicationController
  skip_before_filter :authorize

  def create
    user= User.find_by_username(params[:username])
    
    respond_to do |format|
      if user and user.authenticate(params[:userpassword])
         session[:user_id] = user.id
         user.update_last_login_date
         format.json {render json: {:result=>"success"}}   
      else
         format.json {render json: {:result=>"failure"}}     
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path 
  end
  
end
