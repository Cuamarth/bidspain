module BidHelper
  
  public
  def self.check_bids_end
    bids =Bid.find :all,:conditions => ["active =? and closed=?", "1","0" ]
    actualTime=Time.now
    bids.each do |bid|
      oldPlace=bid.place      
      bid.checkIfHasEnded(actualTime)
      if (bid.closed and bid.autorenewal) then 
            newBid=Bid.new
            newBid.product_id=bid.product_id
            newBid.place=oldPlace
            newBid.nbids_max=bid.nbids_max
            newBid.maxbid=bid.maxbid
            newBid.cost_per_bid=bid.cost_per_bid
            newBid.firstBidTime=bid.firstBidTime
            newBid.renewalTime=bid.renewalTime
            newBid.nbids =0
            newBid.price =bid.price               
            newBid.closed=false
            newBid.userwiner=0
            newBid.endingTime=Time.now+newBid.firstBidTime.hour.hours+newBid.firstBidTime.min.minutes  
            newBid.active=true
            newBid.autorenewal=true
            newBid.save
   
      end
    end
  end
  
  def getUserNameFromId(id)
    User.find(id).username
  end
  
end


