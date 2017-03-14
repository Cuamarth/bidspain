class Order < ActiveRecord::Base  
  attr_protected  
  belongs_to :product
  belongs_to :user
  


end
