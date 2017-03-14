class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :bid
  STATUS_TYPES = [ "1", "2","3" ]
  attr_accessor :euros,:cents,:halfbid,:freebid
  attr_accessible :euros,:cents,:bid_id,:user_id,:status,:quantity,:halfbid,:freebid
  HUMANIZED_ATTRIBUTES = {
  :euros => "La Puja",
  :cents => "La Puja",
  :quantity => "bet",
  :bid_id => "La subasta",
  :user_id => "Tu cuenta"
  }
  paginates_per 20
  
  before_validation :set_quantity
  before_create :check_data_before_create
  after_create :updateAppData
  validates  :quantity, presence: true
  validates  :quantity ,numericality:  {greater_than_or_equal_to: 0.01 }
  validates  :euros ,numericality:  {greater_than_or_equal_to: 0.00}
  validates  :cents ,numericality:  {greater_than_or_equal_to: 0.00 }
  validates :base,bet:true

  

  def self.human_attribute_name(attr, options={})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  def check_data_before_create    
    self.status="1"
    #Here we check if we have bids with the same quantity and change their status
    #bets=Bet.find_by_quantity_and_bid_id(self.quantity,self.bid_id)
    bets=Bet.find :all,:conditions => ["quantity =? AND bid_id=?", self.quantity,self.bid_id ]
    if bets!=nil and bets.size>0 then 
      self.status="3" if bets.size>1
      self.status="2" if bets.size==1
      
      bets.each do |bet|
        bet.update_attribute('status',self.status)        
      end
      
    end
    
  end
  
  def updateAppData
    multiplicator=1
    if self.halfbid=="true" then
      multiplicator=0.5 
      self.user.update_attribute("halfbids",self.user.halfbids-1)
    elsif self.freebid=="true" then
      multiplicator=0
      self.user.update_attribute("freebids",self.user.freebids-1)  
    end
    self.update_attribute("realpaid",self.bid.cost_per_bid*multiplicator)
    self.user.update_attribute("money",(self.user.money-(self.bid.cost_per_bid*multiplicator)))   
    self.bid.update_attribute("nbids",(self.bid.nbids+1))
 
  end
  
  
  def status_html
    if (status=="1") then 
      return I18n. t "bidspain.common.unique"
    elsif (status=="2") then
      return I18n. t "bidspain.common.duplicated"
    else
      return I18n. t "bidspain.common.disqualified"
    end
  end
  def self.getMaxBettersByRange(startDate,endDate)
    bets=Bet.where("created_at >=? and created_at<=?",startDate,endDate)
    usersMap=Hash.new
    
    bets.each do |bet|
      user=usersMap[bet.user.username]
      if (user==nil)
        user=bet.user     
        user.betsdone=1
      else
        user.betsdone=user.betsdone+1
      end
      usersMap[user.username]=user
    end
    return (usersMap.values.sort_by{|u| -u.betsdone})
 
  end
  
  def successMessage
    if self.status=="1" then 
      I18n.t  "bidspain.bids.betunique"
    elsif self.status=="2" then
      I18n.t  "bidspain.bids.betduplicated"
    else
      I18n.t  "bidspain.bids.betdisqualify"
    end
  end
  
  private
  def set_quantity
    
    self.quantity=(self.euros+"."+self.cents)

  end
  


end
