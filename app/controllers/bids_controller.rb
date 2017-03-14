class BidsController < ApplicationController

  def index
    @User =current_user
    @bids =Bid.find :all,:conditions => ["active =?", "1" ],:order => 'place'
    
  end

  def bidTime    
    bid=Bid.find(params[:id])
    
    respond_to do |format|
      if (bid.endingTime<Time.now) then
          format.json {render json: {:ended =>  bid.closed,:tryagain=>"true"}}  
      else
        format.json  { render :json => bid.getRemainingTime }
      end
    end
  end
  
  def show
    @User =current_user
    @bid=Bid.find :first,:conditions => ["id =? ",params[:id] ] 
    @recentBids=Historicalbid.page(1).per(5).order('created_at ASC')

    if (@bid==nil or !@bid.active) then
      redirect_to :root
    else
      @title=@bid.product.localicedTitle
      @bets=@bid.bets.page(params[:page]).per(params[:per]).order('status ASC,quantity DESC,created_at ASC')
      @page=(params[:page].to_i) if params[:page]
      respond_to do |format|
          format.html
          format.js
      end
    end
  end
  
  
  
   
end
