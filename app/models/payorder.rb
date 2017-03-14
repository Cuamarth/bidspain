class Payorder < ActiveRecord::Base
  require 'digest/sha1'
  set_table_name "pay_orders"

  #Order Status
  #0 - Not Paid
  #1 - Paid Paypal/ceca
  #2 - Failed
  #3 _ atacck atempt
  PAY_TYPES = [ "paypal", "visa" ] 
    
  include ActionView::Helpers::NumberHelper  
  attr_accessor :ref
  attr_accessible :money,:paytype,:ref
  

  
  belongs_to :user
  
  before_update :updateUserMoney
  validates  :money,:paytype, presence: true
  validates  :money,numericality:  {greater_than_or_equal_to: 5.00}
  validates  :paytype,inclusion: PAY_TYPES
  


  def paypal_url
     values= {
       :bussiness => "vendedor@bidspain.com",
       :cmd => '_xclick',
       :upload => 1,
       :return =>"heroku.bidspain.com/user/wallet",
       :invoice => self.id,
       :image_url => "heroku.bidspain.com/public/img/logo.png",
       :currency_code =>"EUR",
       :amount => self.money,
       :item_name => "#{number_to_currency(self.money)} en creditos bidspain"
     }
     return "https://paypal.com/webscr?"+ values.to_query
  end  
  
  
  def updateUserMoney
    oldOrder=Payorder.find(self.id)
    if (oldOrder.status==0 and self.status==1)
       moneytoUpdate=self.money
       payOrders=Payorder.find :all,:conditions => ["status =?  and user_id=? ", "1",self.user.id ],:order => 'updated_at'
       if (payOrders==nil or !payOrders.any?) then 
         moneytoUpdate=moneytoUpdate*2
       end
       
       self.user.update_attribute("money",(self.user.money+moneytoUpdate))         
    end
  end

  def cecamoney
    return self.money*100
  end
  def creatececasign
    stringtoencode=Rails.configuration.ceca_shakey
    stringtoencode+=Rails.configuration.ceca_merchantID
    stringtoencode+=Rails.configuration.ceca_acquirerBIN
    stringtoencode+=Rails.configuration.ceca_terminalID
    stringtoencode+=self.id.to_s
    stringtoencode+=(self.money*100).to_s
    stringtoencode+="978"
    stringtoencode+="2"
    stringtoencode+="SHA1"
    stringtoencode+=Rails.configuration.pay_callback_url
    stringtoencode+=Rails.configuration.pay_callback_url
    
    Digest::SHA1.hexdigest(stringtoencode).to_s
  end
  def creatececavalidatesign
    
    
    
    stringtoencode=Rails.configuration.ceca_shakey
    stringtoencode+=Rails.configuration.ceca_merchantID
    stringtoencode+=Rails.configuration.ceca_acquirerBIN
    stringtoencode+=Rails.configuration.ceca_terminalID
    stringtoencode+=self.id.to_s
    stringtoencode+=moneyToCompareToCeca
    stringtoencode+="978"
    stringtoencode+="2"    
    stringtoencode+=self.ref

       
    
    Digest::SHA1.hexdigest(stringtoencode).to_s
  end
  
  def moneyToCompareToCeca
    money=(self.money*100).to_s
    if(money.length<12) then
      dif=12-money.length
      
      for i in 1..dif
        money="0"+money
      end
      
    end
     
    Rails.logger.info("Calculated money:"+money)
    return money
     
  end
  
  def self.paytypes
    return [["Paypal","paypal"],["Visa","visa"]]
  end
  
  def self.statusTypes
    return [["No completada","0"],["Correctamente pagada","1"],["Fallada","2"],["Intento de ataque","3"]]
  end

end