class Offercode < ActiveRecord::Base  
  set_table_name "offer_codes"

  attr_protected  
  has_many :offeruses,:dependent => :delete_all
  
  validates  :code,:freebids,:halfbids,:moneyQuantity,:startdate,:enddate, presence: true
  validates  :freebids,:halfbids,:moneyQuantity,numericality:  {greater_than_or_equal_to: 0.00}
  validates  :code,uniqueness: true

     

end