require 'bcrypt'
class User < ActiveRecord::Base   
  include BCrypt
  SEX_TYPES = [ "Hombre", "Mujer" ] 

  attr_protected
  attr_accessor :newPassword,:oldPassword,:confirmPassword,:validatePassword,:terms_of_service,:older_enough,:validateTerms,:betsdone

  after_initialize :set_up_user
  has_many :bets,:dependent => :delete_all
  has_many :orders,:dependent => :delete_all
  has_many :pay_orders
  has_many :historicalbets,:dependent => :delete_all
  before_update :check_data_before_update
  before_create :check_data_before_create

  
  validates  :username,:lastname,:name,:mail,:address,:city,:zipcode,:state,:freebids,:halfbids,:country,:sex, presence: true
  validates  :username,:mail,  uniqueness: true
  validates  :freebids,:halfbids ,numericality:  {greater_than_or_equal_to: 0.00}
  validates_length_of :username, :minimum => 6, :maximum => 12
  validates  :sex,inclusion: SEX_TYPES
  validates_format_of :mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates  :base,user:true 



  public
  def set_up_user
    self.country ||="Spain"
    
  end  
 
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
  
  def authenticate(password_passed)
    password_match= self.password==password_passed
    return  (password_match and !self.banned)
  end
           
  def check_password(password)
     if password=="" then
       characters = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
       password=(0..8).map{characters.sample}.join
       return password
     else
       return password
     end 
  end
  
  def  update_last_login_date
     self.update_column("lastlogindate",Time.now)  
  end         
  
  def update_money(newMoney)
     self.update_column("money",self.money+newMoney)
  end

  def update_money_transactions
    
  end
  
  def generate_new_password
    self.newPassword=check_password("")
    self.save
  end
  
  def self.getSexTypes
    return  SEX_TYPES
  end
  def fullName
    return self.name+" "+self.lastname;
  end
  
  private 
  def check_data_before_create
      if (self.newPassword!=nil) then 
       self.password_hash=self.newPassword
     end
      self.password=check_password(self.password_hash)

  end    
       
  def check_data_before_update    
     oldUser=User.find(self.id)
     if (self.newPassword!=nil) then 
       self.password_hash=self.newPassword
     end
     
     if self.password_hash=="" 
       self.password_hash=oldUser.password_hash      
     elsif self.password_hash!=oldUser.password_hash
       self.password=self.password_hash
     end  
    
  end
end
