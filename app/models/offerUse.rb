class Offeruse < ActiveRecord::Base  
  attr_protected  
  belongs_to :offercode
  belongs_to :user
  after_create :updateAppData

  validates :base,offeruse:true 

   
   def updateAppData
    
    self.user.update_attribute("freebids",self.user.freebids+self.offercode.freebids)
    self.user.update_attribute("halfbids",self.user.halfbids+self.offercode.halfbids)
    self.user.update_attribute("money",(self.user.money+self.offercode.moneyQuantity))   
 
  end
end