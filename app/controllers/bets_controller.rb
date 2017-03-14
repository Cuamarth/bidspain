class BetsController < ApplicationController

  def create
     bet=Bet.new(params[:bet])

     respond_to do |format|
        if ((session[:user_id]==nil or !User.find(session[:user_id])) or  bet.bid.closed or !bet.bid.active) then 
            format.json {render json: {:result=>"failure",:errorMessage=> (I18n.t "bidspain.bids.needregister")} }  
        else     
          user=current_user
          bet.user_id=user.id
          if bet.save         
    
             format.json {render json: {:result=>"success",:status=>bet.status,:freeBids =>bet.user.freebids,
              :halfBids =>bet.user.halfbids,:money =>bet.user.money,:bids => bet.bid.nbids ,:leftbids => (bet.bid.leftbids),:successmsg => bet.successMessage }}  
          else
             format.json {render json: {:result=>"failure",:errorMessage=> (I18n.t bet.errors[:bet_error])} }    
          end
        end
      end    
  end
  



end
