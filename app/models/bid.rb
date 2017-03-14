class Bid < ActiveRecord::Base  
  attr_accessor :places
  attr_protected  
  belongs_to :product
  has_many :bets,:dependent => :delete_all,:order => 'status ASC,quantity DESC,created_at ASC'
  before_save :check_data
  before_create :check_data_on_create
  
  validates  :product_id,:price,:nbids_max,:maxbid,:cost_per_bid,:firstBidTime,:renewalTime, presence: true
  validates  :price,:nbids_max,:maxbid,:cost_per_bid ,numericality:  {greater_than_or_equal_to: 0.00}
  validates  :place,numericality:  {lower_than_or_equal_to: 50}
  validates  :base,bid:true
  
  
  def check_data      
    if (self.active) then active_bid() end  
    
    if (self.closed and  self.id!=nil and  !Bid.find(self.id).closed )
      closeBid
    end  
      
  end
  
  def check_data_on_create
    self.nbids =0
    self.closed=false
    self.userwiner=0    
  end
  
  def active_bid
    if (self.id==nil or  !Bid.find(self.id).active) then 
      self.endingTime=Time.now+self.firstBidTime.hour.hours+self.firstBidTime.min.minutes        
    end
    
  end
  

  
  def getPlaces
    if self.places==nil then 
      return Place.get_total_places
    else
      return self.places
    end
  end

  
  def checkIfHasEnded(time)
    if (time>self.endingTime and self.nbids<self.nbids_max)
      newEndTime=Time.now+self.renewalTime.hour.hours+self.renewalTime.min.minutes  
      self.update_attribute("endingTime",newEndTime)
    elsif (time>self.endingTime and self.nbids>=self.nbids_max)
      closeBid
    end
  end
  
  
  def closeBid
      self.update_column("closed",true) 
      self.update_column("active",false)
      self.update_column("place",0)
      bets=self.bets.order('status ASC,quantity DESC,created_at ASC')
      if (bets!=nil and bets.size>0) then
        self.update_column("userwiner",bets[0].user.id)
        self.update_column("winnerquantity",bets[0].quantity)
        BidMailer.bid_won(bets[0].user,self).deliver

      end     
      
  end
    
  def getRemainingTime
    diff = (self.endingTime-Time.now).abs
    day_diff = diff % 1.week.seconds
    hour_diff = day_diff % 1.day.seconds
    minute_diff = hour_diff % 1.hour.seconds
    hours = ((hour_diff - minute_diff) / 1.hour.seconds).round(0)
    second_diff = minute_diff % 1.minute.second
    minutes = ((minute_diff - second_diff) / 1.minute.seconds).round(0)
    fractions = second_diff % 1
    seconds = ((second_diff - fractions)).round(0)
    
    s=Struct.new( :hours, :minutes, :seconds)
    s.new(putZeroToDate(hours), putZeroToDate(minutes), putZeroToDate(seconds))
    
   
  end
  
  def leftbids
    leftbids=self.nbids_max-self.nbids
    if (leftbids <0) then
      leftbids=0
    end
    return leftbids
  end
  
  def paybid
     self.update_column("paid",true)   
     if (self.product.ptype=="Dinero") then 
       self.update_column("userconfirmed",true)
     end  

  end
  
  def shareurl
    return "http://www.bidspain.com/bids/"+self.id.to_s
  end
  
  def getEarnedMoney
    return self.bets.sum("realpaid")
  end
  

  private
  def putZeroToDate(timeFraction)
    if (timeFraction<10) then
      timeFraction="0"+timeFraction.to_s
    end
    return timeFraction
  end
  


end
