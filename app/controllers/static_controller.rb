class StaticController < ApplicationController
  
  def info
    @User=current_user
  end
  
  def whoweare
     @User=current_user
  end
  
end
